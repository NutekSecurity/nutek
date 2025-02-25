use std::process::{Command, Stdio};
use std::io::{self, Write, Read};
use std::sync::{Arc, atomic::{AtomicBool, Ordering}};
use std::thread;

fn main() {
    let mut child = Command::new("bash")
        .arg("trash.sh")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("Failed to execute script");

    let mut stdin = child.stdin.take().expect("Failed to open stdin");
    let stdout = child.stdout.take().expect("Failed to open stdout");
    let stderr = child.stderr.take().expect("Failed to open stderr");

    // Create a thread to read stdout
    let stdout_thread = thread::spawn(move || {
        let mut buffer = [0; 128];
        let mut stdout_reader = stdout;
        loop {
            let n = stdout_reader.read(&mut buffer).expect("Failed to read stdout");
            if n == 0 {
                break;
            }
            io::stdout().write_all(&buffer[..n]).expect("Failed to write to stdout");
        }
    });

    // Create a thread to read stderr
    let stderr_thread = thread::spawn(move || {
        let mut buffer = [0; 128];
        let mut stderr_reader = stderr;
        loop {
            let n = stderr_reader.read(&mut buffer).expect("Failed to read stderr");
            if n == 0 {
                break;
            }
            io::stderr().write_all(&buffer[..n]).expect("Failed to write to stderr");
        }
    });

    // Shared flag to signal input thread to stop
    let stop_flag = Arc::new(AtomicBool::new(false));
    let stop_flag_clone = Arc::clone(&stop_flag);

    // Read user input and send to stdin of the child process
    let input_thread = thread::spawn(move || {
        let mut input = String::new();
        while !stop_flag_clone.load(Ordering::SeqCst) {
            if io::stdin().read_line(&mut input).expect("Failed to read line") > 0 {
                if let Err(e) = stdin.write_all(input.as_bytes()) {
                    if e.kind() == io::ErrorKind::BrokenPipe {
                        break;
                    } else {
                        panic!("Failed to write to stdin: {:?}", e);
                    }
                }
                input.clear();
            }
        }
    });

    // Wait for the child process to finish
    let output = child.wait().expect("Failed to wait on child");

    // Signal the input thread to stop
    stop_flag.store(true, Ordering::SeqCst);

    // Wait for all threads to finish
    stdout_thread.join().expect("Failed to join stdout thread");
    stderr_thread.join().expect("Failed to join stderr thread");
    input_thread.join().expect("Failed to join input thread");

    if !output.success() {
        eprintln!("Script exited with status: {}", output);
    }
}