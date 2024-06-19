# env command to find sh in the user's PATH, making it more portable across different Unix-like systems.
#!/usr/bin/env sh

# makes the script exit immediately if any command returns a non-zero exit status. This is useful for:
# Preventing the script from continuing when an error occurs.
# Ensuring that any error is caught and handled appropriately.
set -e

# Function to check if a command exists
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# Function to display error messages
fmt_error() {
  printf "\033[31m%s\033[0m\n" "$*" >&2
}

# Ensure necessary commands are available
if ! command_exists curl; then
  fmt_error "curl is not installed. Please install curl first."
  exit 1
fi

if ! command_exists git; then
  fmt_error "git is not installed. Please install git first."
  exit 1
fi

# Set the installation directory
INSTALL_DIR="$HOME/.create-poetry-app"

# Clone the repository
echo "Cloning create-poetry-app..."
git clone https://github.com/aifirstd3v/create-poetry-app.git "$INSTALL_DIR"

# Create a symbolic link to make create-poetry-app globally accessible
echo "Setting up create-poetry-app..."
ln -sf "$INSTALL_DIR/create-poetry-app" /usr/local/bin/create-poetry-app

# Confirm installation
echo "create-poetry-app installed successfully!"