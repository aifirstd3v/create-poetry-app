#!/usr/bin/env sh

# Makes the script exit immediately if any command returns a non-zero exit status.
set -e

# Function to display information about the script
display_info() {
  echo "⚠️  Welcome to the create-poetry-app Uninstaller!"
  echo
  echo "This script will guide you through the uninstallation process of create-poetry-app."
  echo "Here's what will happen:"
  echo
  echo "1. ❓ Confirming if you want to uninstall create-poetry-app."
  echo "2. 🗑️  Removing the create-poetry-app installation directory."
  echo "3. 🔗  Removing the symbolic link."
  echo "4. 🔧  Removing create-poetry-app from your PATH in your shell configuration file."
  echo
  echo "Let's proceed with the uninstallation. ⚠️"
  echo
}

# Function to display error messages
fmt_error() {
  printf "\033[31m%s\033[0m\n" "$*" >&2
}

# Function to confirm uninstallation
confirm_uninstallation() {
  read -r -p "Are you sure you want to remove create-poetry-app? [y/N] " confirmation
  if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
    echo "Uninstall cancelled."
    exit
  fi
}

# Function to remove installation directory
remove_installation_directory() {
  if [ -d "$HOME/.create-poetry-app" ]; then
    echo "Removing $HOME/.create-poetry-app..."
    rm -rf "$HOME/.create-poetry-app"
    echo "Installation directory removed."
  else
    echo "$HOME/.create-poetry-app does not exist. Skipping."
  fi
}

# Function to remove symbolic link
remove_symbolic_link() {
  if [ -L /usr/local/bin/create-poetry-app ]; then
    echo "Removing /usr/local/bin/create-poetry-app..."
    sudo rm -f /usr/local/bin/create-poetry-app
    echo "Symbolic link removed."
  else
    echo "/usr/local/bin/create-poetry-app does not exist. Skipping."
  fi
}

# Function to determine the user's shell and shell configuration file
determine_shell_config() {
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      ;;
    *)
      fmt_error "Unsupported shell: $SHELL_NAME. Please manually remove the create-poetry-app path from your PATH."
      exit 1
      ;;
  esac
}

# Function to remove the create-poetry-app PATH modification from the shell configuration file
remove_path_modification() {
  if [ -f "$SHELL_CONFIG" ]; then
    echo "Removing create-poetry-app from your PATH in $SHELL_CONFIG..."
    sed -i.bak "\|export PATH=\"$HOME/.create-poetry-app:\$PATH\"|d" "$SHELL_CONFIG"
    echo "PATH modification removed."
    echo "A backup of your original shell configuration file has been created: $SHELL_CONFIG.bak"
    # Reload shell configuration
    if [ -n "$BASH_SOURCE" ]; then
      source "$SHELL_CONFIG"
    else
      . "$SHELL_CONFIG"
    fi
  else
    fmt_error "$SHELL_CONFIG not found. Please manually remove the create-poetry-app path from your PATH."
  fi
}

# Main function to uninstall create-poetry-app
main() {
  # Display information
  display_info

  # Confirm uninstallation
  confirm_uninstallation

  # Remove installation directory
  remove_installation_directory

  # Remove symbolic link
  remove_symbolic_link

  # Determine the shell and configuration file
  determine_shell_config

  # Remove PATH modification
  remove_path_modification

  # Confirm uninstallation
  echo "Thanks for trying out create-poetry-app. It's been uninstalled. 🚮"
  echo "Don't forget to restart your terminal! 🖥️"
}

# Run the main function
main
