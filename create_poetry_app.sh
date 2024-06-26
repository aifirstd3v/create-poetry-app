#!/usr/bin/env sh

set -e

# This script automates the process of creating a new Python project using Poetry.
# It allows the user to specify the project name, author name, author email, Python version,
# the upper limit of the Python version, and whether to create the virtual environment
# inside the project directory. The script also updates the pyproject.toml file
# with the specified Python version, description, and authors.

# Default values
DEFAULT_PROJECT_NAME="projectname"
DEFAULT_MY_NAME="main"
DEFAULT_PYTHON_VERSION="^3.12"
DEFAULT_VENV_CONFIG="true"
DEFAULT_DESCRIPTION="description"
DEFAULT_AUTHOR_NAME="Your Name"
DEFAULT_AUTHOR_EMAIL="you@example.com"

# Initialize variables with default values
PROJECT_NAME=""
MY_NAME=""
PYTHON_VERSION=""
UPPER_PYTHON_VERSION=""
VENV_CONFIG=""
DESCRIPTION=""
AUTHOR_NAME=""
AUTHOR_EMAIL=""
USE_DEFAULTS=false

# Function to validate email format
validate_email() {
  if echo "$1" | grep -Eq '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'; then
    return 0
  else
    return 1
  fi
}

# Function to clean and validate upper Python version format
clean_upper_version() {
  if [ -z "$1" ]; then
    echo ""
  else
    CLEANED_VERSION=$(echo "$1" | tr -d -c '0-9.')
    if echo "$CLEANED_VERSION" | grep -Eq '^[0-9]+\.[0-9]+(\.[0-9]+)?$'; then
      echo "$CLEANED_VERSION"
    else
      echo "Invalid upper Python version format. It should be in the format x.y.z." >&2
      exit 1
    fi
  fi
}

# Function to convert package name to valid format
convert_package_name() {
  echo "$1" | tr '-' '_'
}

# Function to sanitize input before writing to pyproject.toml
sanitize_input() {
  echo "$1" | sed 's/[^0-9.]//g'
}

# Function to parse command line options
parse_options() {
  while getopts "yp:n:v:u:d:a:e:c:" opt; do
    case $opt in
      y) USE_DEFAULTS=true ;;
      p) PROJECT_NAME=$OPTARG ;;
      n) MY_NAME=$OPTARG ;;
      v) PYTHON_VERSION=$OPTARG ;;
      u) UPPER_PYTHON_VERSION=$OPTARG ;;
      d) DESCRIPTION=$OPTARG ;;
      a) AUTHOR_NAME=$OPTARG ;;
      e) AUTHOR_EMAIL=$OPTARG ;;
      c) VENV_CONFIG=$OPTARG ;;
      \?) echo "Invalid option -$OPTARG" >&2 ;;
    esac
  done
}

# Function to prompt for input values if not provided via command line options or use default values
prompt_for_inputs() {
  if [ -z "$PROJECT_NAME" ]; then
    echo "Enter project name (default: $DEFAULT_PROJECT_NAME):"
    read INPUT
    PROJECT_NAME=${INPUT:-$DEFAULT_PROJECT_NAME}
  fi

  if [ "$USE_DEFAULTS" = false ]; then
    if [ -z "$MY_NAME" ]; then
      echo "Enter your package name (default: $DEFAULT_MY_NAME):"
      read INPUT
      MY_NAME=${INPUT:-$DEFAULT_MY_NAME}
    fi
    MY_NAME=$(convert_package_name "$MY_NAME")

    if [ -z "$PYTHON_VERSION" ]; then
      echo "Enter Python version (default: $DEFAULT_PYTHON_VERSION, e.g., 3.12 or ^3.12 or ~3.12):"
      read INPUT
      PYTHON_VERSION="${INPUT:-$DEFAULT_PYTHON_VERSION}"
    fi

    if [ -z "$UPPER_PYTHON_VERSION" ]; then
      echo "Enter upper Python version limit (optional, numbers only, e.g., 3.33):"
      read INPUT
      UPPER_PYTHON_VERSION=$(clean_upper_version "${INPUT}")
    fi

    if [ -z "$DESCRIPTION" ]; then
      echo "Enter project description (default: $DEFAULT_DESCRIPTION):"
      read INPUT
      DESCRIPTION=${INPUT:-$DEFAULT_DESCRIPTION}
    fi

    if [ -z "$AUTHOR_NAME" ]; then
      echo "Enter author name (default: $DEFAULT_AUTHOR_NAME):"
      read INPUT
      AUTHOR_NAME=${INPUT:-$DEFAULT_AUTHOR_NAME}
    fi

    if [ -z "$AUTHOR_EMAIL" ]; then
      while true; do
        echo "Enter author email (default: $DEFAULT_AUTHOR_EMAIL):"
        read INPUT
        AUTHOR_EMAIL=${INPUT:-$DEFAULT_AUTHOR_EMAIL}

        if [ -z "$AUTHOR_EMAIL" ] || validate_email "$AUTHOR_EMAIL"; then
          if [ -z "$AUTHOR_EMAIL" ]; then
            AUTHOR_EMAIL=$DEFAULT_AUTHOR_EMAIL
          fi
          break
        else
          echo "Invalid email format. Please enter a valid email address."
        fi
      done
    fi

    if [ -z "$VENV_CONFIG" ]; then
      echo "Set virtualenvs.in-project to true/false (default: $DEFAULT_VENV_CONFIG):"
      read INPUT
      VENV_CONFIG=${INPUT:-$DEFAULT_VENV_CONFIG}
    fi
  else
    MY_NAME=$DEFAULT_MY_NAME
    PYTHON_VERSION=$DEFAULT_PYTHON_VERSION
    UPPER_PYTHON_VERSION=""
    AUTHOR_NAME=$DEFAULT_AUTHOR_NAME
    AUTHOR_EMAIL=$DEFAULT_AUTHOR_EMAIL
    VENV_CONFIG=$DEFAULT_VENV_CONFIG
  fi
}

# Function to set dependency version based on PYTHON_VERSION and UPPER_PYTHON_VERSION
set_dependency_version() {
  if [ -n "$UPPER_PYTHON_VERSION" ]; then
    DEPENDENCY_VERSION=">=$(sanitize_input "$PYTHON_VERSION"),<$(clean_upper_version "$UPPER_PYTHON_VERSION")"
  else
    if echo "$PYTHON_VERSION" | grep -q '^[^0-9]'; then
      DEPENDENCY_VERSION="$PYTHON_VERSION"
    else
      DEPENDENCY_VERSION="^$PYTHON_VERSION"
    fi
  fi
}

# Function to create the pyproject.toml file
create_pyproject_toml() {
  AUTHOR="${AUTHOR_NAME} <${AUTHOR_EMAIL}>"

  cat <<EOL > pyproject.toml
[tool.poetry]
name = "$MY_NAME"
version = "0.1.0"
description = "$DESCRIPTION"
authors = ["$AUTHOR"]
readme = "README.md"
packages = [{include = "$MY_NAME", from = "src"}]

[tool.poetry.dependencies]
python = "$DEPENDENCY_VERSION"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
EOL
}

# Main function to create the project
main() {
  # Parse command line options
  parse_options "$@"

  # Prompt for inputs if necessary
  prompt_for_inputs

  # Set dependency version
  set_dependency_version

  # Create a new Poetry project
  poetry new "$PROJECT_NAME" --name "$MY_NAME" --src

  # Change to the project directory
  cd "$PROJECT_NAME" || exit

  # Create pyproject.toml
  create_pyproject_toml

  # Output the contents of pyproject.toml to the console
  echo "Generated pyproject.toml:"
  cat pyproject.toml

  # Configure Poetry to create virtual environments inside the project directory if specified
  poetry config virtualenvs.in-project "$VENV_CONFIG"

  # Use the specified Python version for the project's virtual environment
  ESCAPED_PYTHON_VERSION=$(sanitize_input "$PYTHON_VERSION")
  echo "Using Python $ESCAPED_PYTHON_VERSION for poetry env use"
  poetry env use "$ESCAPED_PYTHON_VERSION"

  # Install the project dependencies
  poetry install

  # Activate the virtual environment
  . .venv/bin/activate

  # Print a success message
  echo "Project '$PROJECT_NAME' created and virtual environment activated with Python $PYTHON_VERSION"
}

# Run the main function
main "$@"
