use std::error::Error;
use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};

use reqwest;

async fn download_and_run_script(url: &str) -> Result<(), Box<dyn Error>> {
    // 1. Download the script content.
    let response = reqwest::get(url).await?;
    let script_content = response.text().await?;

    // 2. Prepare the command to execute the script.
    //    We use bash -c "..."  to execute the script content as a single command.
    //    This avoids the need for writing to a file, and then executing.
    let mut child = Command::new("bash")
        .arg("-c")
        .arg(script_content)
        .stdout(Stdio::piped()) // Capture standard output
        .stderr(Stdio::piped()) // Capture standard error
        .spawn()?; // Start the command

    // 3.  Read and print output and error streams concurrently.
    //     This ensures we see output as it happens, not just at the end.
    //     We use separate threads to handle stdout and stderr independently
    //     to avoid deadlocks if one stream is blocked while the other has data.
    let stdout = child.stdout.take().ok_or("Failed to capture stdout")?;
    let stderr = child.stderr.take().ok_or("Failed to capture stderr")?;

    // Thread for handling stdout
    let stdout_thread = std::thread::spawn(move || {
        let reader = BufReader::new(stdout);
        for line in reader.lines() {
            match line {
                Ok(l) => println!("{}", l),
                Err(e) => eprintln!("Error reading stdout: {}", e), // Log errors appropriately
            }
        }
    });

    // Thread for handling stderr
    let stderr_thread = std::thread::spawn(move || {
        let reader = BufReader::new(stderr);
        for line in reader.lines() {
            match line {
                Ok(l) => eprintln!("{}", l), // Print stderr to stderr!
                Err(e) => eprintln!("Error reading stderr: {}", e), // Log errors appropriately
            }
        }
    });

    // Wait for the child process to finish and get the exit status.
    let status = child.wait()?;

    // Wait for the stdout and stderr threads to complete.
    stdout_thread.join().expect("stdout thread panicked");
    stderr_thread.join().expect("stderr thread panicked");

    // 4. Check the exit status.
    if status.success() {
        println!("Script executed successfully.");
    } else {
        eprintln!("Script exited with error code: {}", status);
    }
    Ok(())
}

#[tokio::main]
async fn main() {
    // Get the URL from the command line arguments, or use a default
    let _: Vec<String> = std::env::args().collect();
    let url = "https://raw.githubusercontent.com/NutekSecurity/nutek/refs/heads/main/trash.sh";

    if let Err(e) = download_and_run_script(&url).await {
        eprintln!("Error: {}", e);
    }
}
