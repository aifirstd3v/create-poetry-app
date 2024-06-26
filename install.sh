#!/usr/bin/env sh

set -e

# Function to display information about the script
display_info() {
  echo "🚀 Welcome to the create-poetry-app Installer!"
  echo
  echo "This script will guide you through the installation process of create-poetry-app."
  echo "Here's what will happen:"
  echo
  echo "1. 🛠️  Checking for required dependencies (curl, git, and Python)."
  echo "2. 📥  Cloning the create-poetry-app repository to your home directory."
  echo "3. 🔗  Creating a symbolic link to make create-poetry-app accessible from anywhere."
  echo "4. 🔧  Adding create-poetry-app to your PATH in your shell configuration file."
  echo "5. 📦  Installing necessary Python packages if Python version is selected."
  echo
  echo "Let's get started! 🚀"
  echo
}

# Function to check if a command exists
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# Function to display error messages
fmt_error() {
  printf "\033[31m%s\033[0m\n" "$*" >&2
}

# Function to clone the repository
clone_repo() {
  echo "Cloning create-poetry-app..."
  git clone https://github.com/aifirstd3v/create-poetry-app.git "$INSTALL_DIR"
}

# Function to create a symbolic link
create_symlink() {
  echo "Setting up create-poetry-app..."
  sudo ln -sf "$INSTALL_DIR/$1" /usr/local/bin/create-poetry-app
  sudo chmod +x "$INSTALL_DIR/$1"
}

# Function to add create-poetry-app to the PATH in the shell configuration file
add_to_path() {
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    *)
      fmt_error "Unsupported shell: $SHELL_NAME. Please add $INSTALL_DIR and /usr/local/bin to your PATH manually."
      exit 1
      ;;
  esac

  # Add INSTALL_DIR to PATH if not already present
  if ! grep -q "$INSTALL_DIR" "$SHELL_CONFIG"; then
    echo "Adding $INSTALL_DIR to your PATH in $SHELL_CONFIG..."
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_CONFIG"
  else
    echo "$INSTALL_DIR is already in your PATH."
  fi

  # Add /usr/local/bin to PATH if not already present
  if ! grep -q '/usr/local/bin' "$SHELL_CONFIG"; then
    echo "Adding /usr/local/bin to your PATH in $SHELL_CONFIG..."
    echo 'export PATH="/usr/local/bin:$PATH"' >> "$SHELL_CONFIG"
  else
    echo "/usr/local/bin is already in your PATH."
  fi

  source "$SHELL_CONFIG"
}

# Function to check and install necessary dependencies
check_dependencies() {
  if ! command_exists curl; then
    fmt_error "curl is not installed. Please install curl first."
    exit 1
  fi

  if ! command_exists git; then
    fmt_error "git is not installed. Please install git first."
    exit 1
  fi

  if [ "$INSTALL_TYPE" = "python" ]; then
    if ! command_exists python3; then
      fmt_error "Python is not installed. Please install Python first."
      exit 1
    fi
    if ! command_exists pip3; then
      fmt_error "pip is not installed. Please install pip first."
      exit 1
    fi
  fi
}

# Function to prompt user for installation type
prompt_installation_type() {
  echo "Which version of create-poetry-app would you like to install?"
  echo "1. Shell version"
  echo "2. Python version"
  read -p "Enter your choice (1 or 2): " choice
  case $choice in
    1) INSTALL_TYPE="shell" ;;
    2) INSTALL_TYPE="python" ;;
    *)
      fmt_error "Invalid choice. Please enter 1 or 2."
      exit 1
      ;;
  esac
}

# Function to check if the installation directory exists and prompt for action
check_existing_installation() {
  if [ -d "$INSTALL_DIR" ]; then
    echo "The installation directory $INSTALL_DIR already exists."
    read -p "Do you want to remove the existing directory and reinstall? [y/N] " response
    case $response in
      [yY][eE][sS]|[yY])
        echo "Removing existing directory..."
        rm -rf "$INSTALL_DIR"
        ;;
      *)
        echo "Installation aborted."
        exit 1
        ;;
    esac
  fi
}

# Function to install Python dependencies if the Python version is selected
install_python_dependencies() {
  if [ "$INSTALL_TYPE" = "python" ]; then
    echo "Installing Python dependencies..."

    # Log the packages to be installed
    echo "The following packages will be installed:"
    cat "$INSTALL_DIR/requirements.txt"

    # Install the packages
    pip3 install -r "$INSTALL_DIR/requirements.txt"
  fi
}

# Main function to install create-poetry-app
main() {
  # Display information
  display_info

  # Prompt for installation type
  prompt_installation_type

  # Ensure necessary commands are available
  check_dependencies

  # Set the installation directory
  INSTALL_DIR="$HOME/.create-poetry-app"

  # Check for existing installation
  check_existing_installation

  # Clone the repository
  clone_repo

  # Create a symbolic link to make create-poetry-app globally accessible
  if [ "$INSTALL_TYPE" = "shell" ]; then
    create_symlink "create-poetry-app.sh"
  elif [ "$INSTALL_TYPE" = "python" ]; then
    create_symlink "create_poetry_app.py"
  fi

  # Add create-poetry-app to the PATH in the shell configuration file if needed
  add_to_path

  # Install Python dependencies if needed
  install_python_dependencies

  # Confirm installation
  echo "create-poetry-app installed successfully! 🎉"
}

# Run the main function
main
