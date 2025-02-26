##!/usr/bin/env bash

if ! [[ "$(uname -s)" == "Darwin" ]]; then
    echo "🚀 This script is temporairly for macOS only and need some Polish."
    exit 1
else
    echo "💻 You are on macOS"
fi


echo "🚀 You need internet connection..."

# Function to check if running inside a container
is_container() {
    if [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then
        return 0
    else
        return 1
    fi
}

# Cr$SUDO a Bash array (in this case, let's say we want to install some packages)
packages_to_install=(
   "ollama" # - run LLM locally
   "podman" # - docker alternative
   "act" # - run GitHub workflows locally
   "neovim" # - text editor
   "irssi" # - irc client
   "dos2unix" # - convert dos to unix
   "ipcalc" # - ip calculator
   "subnetcalc" # "whatmask" # - ip calculator # Warning: whatmask has been deprecated because it has a removed upstream repository! It will be disabled on 2025-02-28.
   "expect" # - automate interactive applications
   "fd" # - find alternative
   "tmux" # - terminal multiplexer
   "lsd" # - ls alternative
   "bat" # - cat alternative
   "ripgrep-all" # - grep alternative
   "sd" # - sed alternative
   "smap" # - map network
   "nmap" # - network scanner
   "p0f" # - passive os fingerprinting
   "masscan" # - port scanner
   "gobuster" # - directory bruteforcer
   "feroxbuster" # - directory bruteforcer
   "ffuf" # - directory bruteforcer
   "nuclei" # - vulnerability scanner
   "recon-ng" # - reconnaissance framework
   "mitmproxy" # - transparent proxy
   "metasploit" # - red team toolbox
   "httpx" # - http scanner
   "amass" # - subdomain scanner
   "jq" # - json parser
   "htmlq" # - html parser
   "httrack" # - website copier
   "monolith" # - website copier
   "httpie" # - curl alternative
   "glow" # "mdcat" # - markdown reader # Warning: mdcat has been deprecated because it has an archived upstream repository! It will be disabled on 2025-04-05.
   "ouch" # - archive extractor
   "exploitdb" # - exploit database
   "asciinema" # - terminal recorder
   "agg" # - ascii art generator
   "crunch" # - wordlist generator
   "mdbook" # - book generator
   "rustscan" # - fast nmap scan (CTF)
   "sqlmap" # - automated SQL Injection
   "bettercap" # - network attacks
   "exiftool" # read/write exif metadata
   ### easiest way to start coding - ask chat after installation
   "powershell" # windows shell
   "pyenv" # - python version manager
   "pyenv-virtualenv" # - virtualenv for pyenv
   "rbenv" # - ruby version manager
   "nvm" # - node version manager
   ### GUI apps
   "diffusionbee" # - AI art generator
   "podman-desktop" # - docker alternative
   "homebrew/cask/httpie" # - curl alternative
   "pgadmin4" # - database administration
   "mysqlworkbench" # - database administration
   "imhex" # - hex editor
   "warp" # - terminal
   "alacritty" # - terminal
   "kitty" # - terminal
   "homebrew/cask/wireshark" # - network analyzer
   "termshark" # - wireshark alternative
   "burp-suite" # - wab app proxy
   "font-hack-nerd-font" # - font
   "zed" # - text editor
   "homebrew/cask/visual-studio-code" # - text editor
   "firefox" # - web browser
   "zap" # - web app scanner
)

# --- Use two indexed arrays ---

declare -a package_names=()
declare -a package_comments=()

# Add packages and comments (keeping the indices in sync)
package_names+=("ollama")
package_comments+=("run LLM locally")

package_names+=("podman")
package_comments+=("docker alternative")

package_names+=("act")
package_comments+=("run GitHub workflows locally")

package_names+=("neovim")
package_comments+=("text editor")

package_names+=("irssi")
package_comments+=("irc client")

package_names+=("dos2unix")
package_comments+=("convert dos to unix")

package_names+=("ipcalc")
package_comments+=("ip calculator")

package_names+=("subnetcalc")
package_comments+=("ip calculator")

package_names+=("expect")
package_comments+=("automate interactive applications")

package_names+=("fd")
package_comments+=("find alternative")

package_names+=("tmux")
package_comments+=("terminal multiplexer")

package_names+=("lsd")
package_comments+=("ls alternative")

package_names+=("bat")
package_comments+=("cat alternative")

package_names+=("ripgrep-all")
package_comments+=("grep alternative")

package_names+=("sd")
package_comments+=("sed alternative")

package_names+=("smap")
package_comments+=("map network")

package_names+=("nmap")
package_comments+=("network scanner")

package_names+=("p0f")
package_comments+=("passive os fingerprinting")

package_names+=("masscan")
package_comments+=("port scanner")

package_names+=("gobuster")
package_comments+=("directory bruteforcer")

package_names+=("feroxbuster")
package_comments+=("directory bruteforcer")

package_names+=("ffuf")
package_comments+=("directory bruteforcer")

package_names+=("nuclei")
package_comments+=("vulnerability scanner")

package_names+=("recon-ng")
package_comments+=("reconnaissance framework")

package_names+=("mitmproxy")
package_comments+=("transparent proxy")

package_names+=("metasploit")
package_comments+=("red team toolbox")

package_names+=("httpx")
package_comments+=("http scanner")

package_names+=("amass")
package_comments+=("subdomain scanner")

package_names+=("jq")
package_comments+=("json parser")

package_names+=("htmlq")
package_comments+=("html parser")

package_names+=("httrack")
package_comments+=("website copier")

package_names+=("monolith")
package_comments+=("website copier")

package_names+=("httpie")
package_comments+=("curl alternative")

package_names+=("glow")
package_comments+=("markdown reader")

package_names+=("ouch")
package_comments+=("archive extractor")

package_names+=("exploitdb")
package_comments+=("exploit database")

package_names+=("asciinema")
package_comments+=("terminal recorder")

package_names+=("agg")
package_comments+=("ascii art generator")

package_names+=("crunch")
package_comments+=("wordlist generator")

package_names+=("mdbook")
package_comments+=("book generator")

package_names+=("rustscan")
package_comments+=("fast nmap scan (CTF)")

package_names+=("sqlmap")
package_comments+=("automated SQL Injection")

package_names+=("bettercap")
package_comments+=("network attacks")

package_names+=("exiftool")
package_comments+=("read/write exif metadata")

package_names+=("powershell")
package_comments+=("windows shell")

package_names+=("pyenv")
package_comments+=("python version manager")

package_names+=("pyenv-virtualenv")
package_comments+=("virtualenv for pyenv")

package_names+=("rbenv")
package_comments+=("ruby version manager")

package_names+=("nvm")
package_comments+=("node version manager")

package_names+=("diffusionbee")
package_comments+=("AI art generator")

package_names+=("podman-desktop")
package_comments+=("docker alternative")

package_names+=("homebrew/cask/httpie")
package_comments+=("curl alternative")

package_names+=("pgadmin4")
package_comments+=("database administration")

package_names+=("mysqlworkbench")
package_comments+=("database administration")

package_names+=("imhex")
package_comments+=("hex editor")

package_names+=("warp")
package_comments+=("terminal")

package_names+=("alacritty")
package_comments+=("terminal")

package_names+=("kitty")
package_comments+=("terminal")

package_names+=("homebrew/cask/wireshark")
package_comments+=("network analyzer")

package_names+=("termshark")
package_comments+=("wireshark alternative")

package_names+=("burp-suite")
package_comments+=("wab app proxy")

package_names+=("font-hack-nerd-font")
package_comments+=("font")

package_names+=("zed")
package_comments+=("text editor")

package_names+=("homebrew/cask/visual-studio-code")
package_comments+=("text editor")

package_names+=("firefox")
package_comments+=("web browser")

package_names+=("zap")
package_comments+=("web app scanner")


# --- Display the numbered list ---

echo "Packages to install:"
for i in "${!package_names[@]}"; do
  printf "%2d. %-30s %s\n" "$((i+1))" "${package_names[$i]}" "${package_comments[$i]}"
done


# --- Ask the user for input ---
echo ""
echo "Enter the numbers of the packages you want to EXCLUDE (comma-separated, or 'all' to exclude all, or press Enter to install all): "
read -r exclude_list

# --- Process the exclusion input ---

if [[ "$exclude_list" == "all" ]]; then
    echo "Excluding all packages. Exiting."
    exit 0
elif [[ -n "$exclude_list" ]]; then
    exclude_indices=($(echo "$exclude_list" | tr ',' ' '))

    # Create temporary arrays to hold the filtered lists
    temp_names=()
    temp_comments=()

    for i in "${!package_names[@]}"; do
        exclude=false
        for idx in "${exclude_indices[@]}"; do
            if [[ "$((i+1))" -eq "$idx" ]]; then
                exclude=true
                break
            fi
        done
        if ! $exclude; then
            temp_names+=("${package_names[$i]}")
            temp_comments+=("${package_comments[$i]}")
        fi
    done

    # Replace the original arrays with the filtered ones
    package_names=("${temp_names[@]}")
    package_comments=("${temp_comments[@]}")
fi

# --- Display packages to install after exclusion ---

echo "Packages to install after exclusion:"
printf '%s\n' "${package_names[@]}"

# Ask the user to confirm before proceeding
echo ""
echo "💛 This script will install the above packages using Homebrew which will be installed shortly."
echo "💛 Please review the list of packages to be installed and confirm..."

echo "Continue installing above packages? (y/n) "

read -n 1 -r choice
echo ""  # Add a newline after the input

case "$choice" in
  y|Y)
    echo "Continuing..."
    # Commands to execute if the user enters 'y' or 'Y'
    ;;
  n|N)
    echo "Exiting..."
    exit 1  # Exit with a non-zero status code to indicate failure (optional)
    ;;
  *)
    echo "Invalid input. Please enter 'y' or 'n'."
    # You might want to loop back here to ask again
    ;;
esac

# Install Rosetta 2
if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(arch)" == "arm64" ]]; then
    echo "💛 Installing Rosetta 2 so all programs can be run, even those for Intel architecture. Please agree to the terms of software license..."
    $SUDO softwareupdate --install-rosetta --agree-to-license
fi

# Check if running inside a container
if is_container; then
    echo "Running inside a container"
    SUDO=""
else
    echo "Not running inside a container"
    SUDO="sudo"
fi

echo "💛 Installing Homebrew... Or updating if already installed."
$SUDO curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/neosb/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "💚 Homebrew is installed."

# Iterate over the array and install each package using brew
# install from Homebrew, dnf, or apt
# may stop for sudo password
echo "💛 Installing selected programs..."
for package in "${package_names[@]}"; do
    if [[ "$(uname -s)" == "Darwin" ]]; then
        # For each package, run a command like this: "brew install $package"
        echo "💛 Installing $package..."
        brew install "$package" || { echo "Error installing $package. Aborting..."; not_installed+=( "$package" ); }
        continue
    fi
    # In case I would like to make nutek linux script
    if [[ "$(un$SUDO-s)" == "Linux" ]] && command -v dnf &> /dev/null; then
        echo "💛 Installing with dnf $package..."
        $SUDO dnf install -y "$package" || echo "$package not in dnf. Trying brew..."; brew install "$package"  || { echo "Error installing $package. Aborting..."; not_installed+=( "$package" ); }
    fi
    if [[ "$(uname -s)" == "Linux" ]] && command -v apt &> /dev/null; then
        echo "💛 Installing with apt $package..."
        $SUDO apt update && $SUDO apt install -y "$package" ||  echo "$package not in apt. Trying brew..."; brew install "$package"  || { echo "Error installing $package. Aborting..."; not_installed+=( "$package" ); }
    fi
    if [[ "$(uname -s)" == "Linux" ]] && command -v packman &> /dev/null; then
        echo "💛 Installing with pacman $package..."
        $SUDO packman --noconfirm -S "$package" ||  echo "$package not in packman. Trying brew..."; brew install "$package"  || { echo "Error installing $package. Aborting..."; not_installed+=( "$package" ); }
    fi
done

echo "💚 All installs done!"

echo "💚 Configuration in ~/.zshrc"
if grep -qF "# ZSH completions" ~/.zshrc; then
    echo "ZSH completions already in file"
else
    echo ""  >> ~/.zshrc
    echo "# ZSH completions" >> ~/.zshrc
    echo 'fpath=($fpath /opt/homebrew/share/zsh/site-functions)' >> ~/.zshrc
    echo "💚 Setup fpath for zsh completions ~/.zshrc..."
fi

if grep -qF "# NVM" ~/.zshrc; then
    echo "NVM already in file"
else
    echo ""  >> ~/.zshrc
    echo "# NVM" >> ~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm' >> ~/.zshrc
    echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> ~/.zshrc
    echo "💚 Setup nvm in ~/.zshrc..."
fi

echo "❤️ Done! Please restart your terminal."
