##!/usr/bin/env bash

if ! [[ "$(uname -s)" == "Darwin" ]]; then
    echo "🚀 This script is temporairly for macOS only and need some Polish."
    echo "Press [Return ⏎] to exit"
    exit 1
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

# Check if running inside a container
if is_container; then
    echo "Running inside a container"
    SUDO=""
else
    echo "Not running inside a container"
    SUDO="sudo"
fi

# Check if Homebrew is installed by looking for the executable in PATH
if ! command -v brew &> /dev/null; then
    echo "❤️ Homebrew not found. Installing..."
    $SUDO curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/neosb/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "💚 Homebrew is installed."
else
    # If already installed, just print a message
    echo "💚 Homebrew is installed."
fi

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

# Print out the array to see what we're working with
echo "Packages to install:"
printf '%s\n' "${packages_to_install[@]}"

not_installed=()

# Install Rosetta 2
if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(arch)" == "arm64" ]]; then
    echo "💛 Installing Rosetta 2 so all programs can be run, even those for Intel architecture. Please agree to the terms of software license..."
    $SUDO softwareupdate --install-rosetta
fi

# Iterate over the array and install each package using brew
# install from Homebrew, dnf, or apt
# may stop for sudo password
echo "💛 Installing selected programs..."
for package in "${packages_to_install[@]}"; do
    if [[ "$(uname -s)" == "Darwin" ]]; then
    $SUDO# For each package, run a command like this: "brew install $package"
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
  $SUDO
done

echo "💚 All installing done!"

echo "💚 Configuration in ~/.zshrc"
echo ""  >> ~/.zshrc
echo "# ZSH completions" >> ~/.zshrc
echo 'fpath=($fpath /opt/homebrew/share/zsh/site-functions)' >> ~/.zshrc
echo "💚 Setup fpath for zsh completions ~/.zshrc..."
echo ""  >> ~/.zshrc
echo "# NVM" >> ~/.zshrc
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm' >> ~/.zshrc
echo `[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion` >> ~/.zshrc
source ~/.zshrc
echo "💚 Setup nvm in ~/.zshrc..."

# Install terminalizer for recording terminal sessions
yarn global add terminalizer

# Print out the array to see what we're working with
echo "❤️ Packages not installed:"
printf '%s\n' "${not_installed[@]}"

echo "🚀 Done! Press [Return ⏎] to exit"
