### README.md

---

# Simpe & Easy Poetry Project Setup Script 🚀

Are you tired of the cumbersome process of setting up a new Python project with specific requirements? Look no further! Our shell script automates the entire process, making your life as a developer smoother and more efficient. Introducing the **Ultimate Poetry Project Setup Script**!

`The issue this project is trying to address was kind of resolved in the lastest version of Poetry, so I believe it will be helpful to users who are still using current version 1.x. The ultimate goal of this project is to upgrade it into a project creation tool with advanced and diverse features, similar to tools like create-react-app and create-next-app, which even the latest version of Poetry does not provide.`

**We have developed both shell script and Python versions, but since advanced features will continue to be added only to the Python version, we recommend using the Python version for installation.**

---

## Features

### Project Initialization
- **Automated Setup**: Automates the creation of new Python projects using Poetry, ensuring a consistent and repeatable project structure.
- **Default Values**: Provides default values for project name, package name, Python version, virtual environment configuration, description, author name, and email, allowing for quick setup.

### Dependency Management
- **Template Support**: Supports project templates (e.g., datascience, ai) with predefined dependencies loaded from a `config.toml` file located in the user's home directory.
- **Dynamic Dependency Versioning**: Automatically sets dependency versions based on user input, ensuring compatibility with specified Python versions.

### Virtual Environment Configuration
- **In-Project Virtual Environment**: Configures Poetry to create virtual environments within the project directory, facilitating isolated and self-contained environments.
- **Deactivation of Existing Environments**: Detects and deactivates any currently active virtual environments to prevent conflicts.

### User-Friendly Prompts
- **Interactive Input**: Prompts the user for project-specific inputs if not provided via command line arguments, ensuring the necessary information is gathered for project setup.
- **Email Validation**: Ensures that the provided author email is in a valid format.

### Logging and Debugging
- **Detailed Logging**: Provides detailed logging for debugging purposes, including information about the user's shell, virtual environment status, and command outputs.
- **Environment Variable Management**: Manages environment variables related to virtual environments and Conda environments, ensuring they are correctly set and unset as needed.

### Visual Feedback
- **ANSI Escape Sequences**: Uses ANSI escape sequences to provide visually distinct and colorful console output, making it easy to identify important information and next steps.

### Comprehensive Setup
- **Automatic Dependency Installation**: Installs project dependencies using Poetry, ensuring the environment is ready for development.
- **Shell Script Generation**: Generates and executes a shell script to activate the virtual environment, providing clear instructions for manual activation if needed.

### Miscellaneous
- **Configurable Shell**: Detects and uses the user's preferred shell for executing commands, ensuring compatibility across different environments.
- **Clean Up and Overwrite**: Handles existing directories gracefully by prompting the user for confirmation before overwriting, ensuring no accidental data loss.

---

## Why Choose Our Script?

Setting up a Python project with specific requirements can be a hassle. Our script eliminates the guesswork and manual edits, letting you focus on what you do best: coding! Here’s why our script stands out:

- **Time-Saving**: Automates repetitive tasks so you can start coding immediately.
- **Error-Free Setup**: Ensures consistent and correct project configurations every time.
- **User-Friendly**: Designed with developers in mind, it’s simple, intuitive, and effective.
- **Customizable**: Adapts to your project needs, ensuring maximum flexibility.

---

## Prerequisites

Before installing `create-poetry-app`, ensure you have the following dependencies installed on your system:

- **Zsh**: Version 4.3.9 or newer is required, but we recommend version 5.0.8 or newer. To check if Zsh is installed and see its version, run:
  ```sh
  zsh --version
  ```
- **Python**: Ensure Python (version 3.6 or higher) is installed. You can check your Python version with `python3 --version`.
- **curl** or **wget**: These tools are used to download the installation script.
  - To check if `curl` is installed, run:
    ```sh
    curl --version
    ```
  - To check if `wget` is installed, run:
    ```sh
    wget --version
    ```

- **git**: Version 2.4.11 or higher is recommended. To check if git is installed and see its version, run:
  ```sh
  git --version
  ```

## Basic Installation using installer script

`create-poetry-app` can be installed by running one of the following commands in your terminal. You can install it via the command-line with either `curl`, `wget`, or another similar tool.

### Method

#### Using curl

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/install.sh)"
```

#### Using wget

```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/install.sh)"
```

#### Using fetch

```sh
sh -c "$(fetch -o - https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/install.sh)"
```

---

## Command-Line Options

The script accepts the following command-line options:

- `-y` : Use default values for all prompts.
- `-p` : Set the project name.
- `-n` : Set the package name.
- `-v` : Set the Python version (supports semver specifiers like `^3.12` or `~3.12`).
- `-u` : Set an optional upper Python version limit.
- `-d` : Set the project description.
- `-a` : Set the author name.
- `-e` : Set the author email.
- `-c` : Set the virtual environment configuration (`true` or `false`).
- `-t` : Set the template name.
- `-h` : Display this help message.

### Examples

#### Example 1: Using Defaults

To create a new project using default values for all prompts:

```sh
create-poetry-app -y
```

#### Example 2: Specifying Project Name and Python Version

To create a new project with a specified name and Python version:

```sh
create-poetry-app -p my_project -v "^3.12"
```

#### Example 3: Full Customization

To create a new project with full customization:

```sh
create-poetry-app -p my_project -n my_package -v "^3.12" -u "3.33" -d "My new project" -a "Smith Neo" -e "aifirstd3v@matrix.universe" -c true
```

### Prompted Input

If any required options are not provided via the command line, the script will prompt for them interactively. For example, running the script without the `-v` option will prompt for the Python version.

---


## Project Templates(Optional): New feature in 1.0.0 🚀

The `create_poetry_app.py` script supports project templates that allow you to predefine dependencies based on the type of project you are creating. This makes it easier to set up projects with common configurations and dependencies.

### Using Templates

You can specify a project template using the `-t` or `--template` option when running the script. For example:

```sh
python create_poetry_app.py -p my_project -t datascience
```

If you do not specify a template via the command line, the script will prompt you to enter one during execution.

### Configuring Templates with config.toml

The templates and their corresponding dependencies are defined in a `config.toml` file. This file should be placed in the same directory as `create_poetry_app.py`.

Here is an example of what your `config.toml` might look like:

```toml
[template.dependency.datascience]
pandas = "^2.2.2"
numpy = ">=1.26.0,<2.0.0"

[template.dependency.ai]
pandas = "^2.2.2"
numpy = ">=1.26.0,<3.0.0"
tensorflow = "^2.4.1"
```

In this example, two templates are defined: `datascience` and `ai`. Each template specifies the dependencies that should be included in the `pyproject.toml` file for projects using that template.

### Adding New Templates

To add a new template, simply edit the `config.toml` file and add a new section under `[template.dependency]` with the name of your template. For example:

```toml
[template.dependency.web]
flask = "^2.0.0"
requests = "^2.25.1"
```

Now you can use the `web` template when creating a new project:

```sh
python create_poetry_app.py -p my_web_project -t web
```

### Example

Here is a full example of using a template to create a new project:

1. Ensure your `config.toml` includes the desired template:
   ```toml
   [template.dependency.datascience]
   pandas = "^2.2.2"
   numpy = ">=1.26.0,<2.0.0"
   ```

2. Run the script with the `-t` option:
   ```sh
   python create_poetry_app.py -p my_datascience_project -t datascience
   ```

The script will automatically include the dependencies specified in the `datascience` template in the `pyproject.toml` file of the new project.
This feature allows you to quickly and consistently set up projects with common dependencies, saving time and reducing errors.



---
## Adding create-poetry-app to Your Shell Configuration(Optional)

If `create-poetry-app` was not installed via `install.sh`, you can manually set it up to make the script easily accessible from anywhere in your terminal. This will allow you to run the script from any directory without needing to specify the full path.

#### For macOS and Linux Users:

1. **Move the Script to a Directory in Your PATH**:

   It's common to move scripts to `/usr/local/bin` so they are in your system's PATH. However, depending on your system configuration, you might use a different directory such as `/usr/bin` or another location included in your PATH. You can find out the directories in your PATH by running `echo $PATH` in your terminal.

   Here is a command to move the script to `/usr/local/bin` and make it executable:

   ```sh
   sudo mv create-poetry-app /usr/local/bin/
   sudo chmod +x /usr/local/bin/create-poetry-app
   ```

   If you prefer to use a different directory, replace `/usr/local/bin/` with your preferred directory.

2. **Add to Shell Configuration File Manually (Optional)**:

   Depending on your shell, you need to add the directory to your PATH in your shell configuration file. The common files are:

   - **Bash**: `~/.bashrc`
   - **Zsh**: `~/.zshrc`

   (You can modify the configuration file according to your system's environment.)

   If you're not sure which shell you are using, you can check by running `echo $SHELL` in your terminal.

   - For **Bash** users, add the following line to your `~/.bashrc` file:

     ```sh
     echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
     source ~/.bashrc
     ```

   - For **Zsh** users, add the following line to your `~/.zshrc` file:

     ```sh
     echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
     source ~/.zshrc
     ```

3. **Reload Your Shell Configuration**:

   After editing the configuration file, you need to reload it to apply the changes:

   - For **Bash** users:

     ```sh
     source ~/.bashrc
     ```

   - For **Zsh** users:

     ```sh
     source ~/.zshrc
     ```

4. **Run the Script from Anywhere**:

   Now you can run the `create-poetry-app` script from any directory by simply typing:

   ```sh
   create-poetry-app
   ```

By following these steps, you'll make `create-poetry-app` easily accessible, streamlining your workflow and allowing you to set up new Poetry projects quickly and efficiently from anywhere in your terminal.

---

## Uninstallation

To uninstall `create-poetry-app`, you can use the `uninstaller.sh` script. Follow these steps:


If `create-poetry-app` is already installed in the `$HOME/.create-poetry-app` directory, you can run the `uninstaller.sh` script directly from that directory:

1. **Navigate to the Installation Directory**:

   ```sh
   cd $HOME/.create-poetry-app
   ```

2. **Make the Script Executable (if not already executable)**:

   ```sh
   chmod +x uninstaller.sh
   ```

3. **Run the Uninstaller Script**:

   ```sh
   ./uninstaller.sh
   ```

OR


#### Using curl

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/uninstaller.sh)"
```

#### Using wget

```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/uninstaller.sh)"
```

#### Using fetch

```sh
sh -c "$(fetch -o - https://raw.githubusercontent.com/aifirstd3v/create-poetry-app/main/uninstaller.sh)"
```


This will remove the `create-poetry-app` installation and any configurations added during the setup.

---

## Basic Poetry Commands and Tips

Here are some essential Poetry commands to help you manage your Python projects efficiently:

| Poetry Command                  | Explanation                                                            |
|---------------------------------|------------------------------------------------------------------------|
| `$ poetry --version`            | Show the version of your Poetry installation.                          |
| `$ poetry new`                  | Create a new Poetry project.                                            |
| `$ poetry init`                 | Add Poetry to an existing project.                                      |
| `$ poetry add <package>`        | Add a package to `pyproject.toml` and install it.                       |
| `$ poetry update`               | Update your project's dependencies.                                     |
| `$ poetry install`              | Install the dependencies.                                               |
| `$ poetry show`                 | List installed packages.                                                |
| `$ poetry check`                | Validate `pyproject.toml`.                                              |
| `$ poetry export`               | Export `poetry.lock` to other formats.                                   |
| `$ poetry config --list`        | Show the Poetry configuration.                                           |
| `$ poetry env list`             | List the virtual environments of your project.                           |
| `$ poetry lock`                 | Pin the latest version of your dependencies into `poetry.lock`.         |
| `$ poetry lock --no-update`     | Refresh the `poetry.lock` file without updating any dependency version. |
| `$ poetry run <command>`        | Execute the given command with Poetry.                                  |

You can check out the [Poetry CLI documentation](https://python-poetry.org/docs/cli/) to learn more about the commands above and the other commands Poetry offers. You can also run `poetry --help` to see information right in your terminal!

---

### Important Poetry Configuration Settings

To maximize the efficiency and usability of Poetry, here are some key configuration settings and additional knowledge you should be aware of:

| Configuration                    | Explanation                                                                                                                                 |
|----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `virtualenvs.in-project`         | Determines whether to create virtual environments within the project directory. Set to `true` to keep the virtual environment in the project folder. |
| `virtualenvs.path`               | Defines the path where virtual environments will be created. By default, this is in a cache directory under your home directory.                   |
| `virtualenvs.prefer-active-python` | If set to `true`, uses the currently active Python version to create new virtual environments. Introduced in Poetry 1.2.0.                               |
| `virtualenvs.prompt`             | Sets the format for the virtual environment prompt. Variables available for formatting include `{project_name}` and `{python_version}`.               |

### Setting Configuration Options

You can set these configuration options using the `poetry config` command. Here are some examples:

- **Set virtual environments to be created within the project directory**:
  ```sh
  poetry config virtualenvs.in-project true
  ```

- **Set the path for virtual environments**:
  ```sh
  poetry config virtualenvs.path "/path/to/your/virtualenvs"
  ```

- **Use the currently active Python version for new virtual environments**:
  ```sh
  poetry config virtualenvs.prefer-active-python true
  ```

- **Customize the virtual environment prompt**:
  ```sh
  poetry config virtualenvs.prompt "{project_name}-py{python_version}"
  ```

### Additional Tips

- **Environment Variables**: Poetry can be configured using environment variables, which can be particularly useful in CI/CD pipelines or when you need temporary settings.
- **Lock Files**: The `poetry.lock` file is crucial for ensuring consistent environments across different setups. Always commit this file to your version control system.
- **Dependency Groups**: Poetry allows you to manage dependencies in groups (e.g., `dev`, `test`). This helps keep your production environment clean and your development environment fully equipped.

By mastering these commands and configuration settings, you can take full advantage of Poetry's powerful features and streamline your Python project management.


---
## Todo

- [ ] Add support for Poetry 2.0 and maintain backward compatibility
- [ ] Add more options and input support

---

Take your Python project setup to the next level. Save time, reduce errors, and get started on your next big idea faster than ever before with our Ultimate Poetry Project Setup Script! 🌟

---

## Feedback & Contributions

We love feedback! If you have any suggestions or improvements, feel free to fork this repository and contribute.

**Happy Coding!** ✨

