# Changelog

## [Unreleased]

### Added

- **Project Initialization**: Automates the creation of new Python projects using Poetry.
- **Shell Script**: Basic Create Poetry App script.

# Changelog

## [v1.1.0] - 2024-06-20

### Added
- **Command-Line and Interactive Prompts**: Added command-line options and interactive prompts for selecting project templates.

### Changed
- **Virtual Environment Path Handling**:
  - Corrected path handling to avoid double project name inclusion.
  - Added checks for existing project directories and prompts for removal if necessary.
- **Environment Variable Management**: Improved handling of environment variables related to virtual environments, ensuring they are correctly unset when deactivating.
- **Debugging Output**: Enhanced debugging output for better traceability and debugging during virtual environment activation.

### Fixed
- **Fixed Issues with Project Path**: Resolved issues with project path handling and virtual environment creation.
- **Improved Logging**: Added detailed logging for virtual environment activation steps, aiding in troubleshooting.


## [v1.0.0] - 2024-06-20

### Added

- **Configuration Parsing**: Parses command-line arguments for project name, package name, Python version, and other configurations.
- **Default Values**: Provides default values for project settings including project name, package name, Python version, virtual environment configuration, description, author name, and email.
- **Template Dependencies**: Supports predefined dependencies based on project templates (e.g., `datascience`, `ai`) loaded from `config.toml`.
- **Interactive Prompts**: Interactive prompts for missing configuration values when not provided via command-line arguments.
- **Email Validation**: Validates the format of the provided author email.
- **Version Cleaning**: Cleans and validates Python version formats.
- **Package Name Conversion**: Converts package names to valid formats by replacing hyphens with underscores.
- **Dependency Version Setting**: Sets dependency versions based on provided Python version and upper version limit.
- **Pyproject.toml Creation**: Generates a `pyproject.toml` file with the specified configurations and dependencies.
- **Project Directory Setup**: Creates the project directory and sets up the initial project structure using `poetry new`.
- **Virtual Environment Configuration**: Configures Poetry to create virtual environments inside the project directory if specified.
- **Python Version Usage**: Ensures the specified Python version is used for the project's virtual environment, with detailed logging for debugging.
- **Dependency Installation**: Installs the project dependencies using Poetry.
- **Virtual Environment Activation**: Activates the virtual environment if `virtualenvs.in-project` is set to `true`.
- **Logging**: Comprehensive logging for debugging and tracing the execution flow, including command outputs and errors.

### Improved

- **Error Handling**: Enhanced error handling for missing or incorrect Python versions, and improved user prompts for better guidance.
- **Code Structure**: Improved code structure for readability and maintainability.

### Fixed

- **Python Version Check**: Fixed issues with detecting and using the correct Python version installed on the system.
- **Template Loading**: Fixed loading and applying template dependencies from `config.toml`.
