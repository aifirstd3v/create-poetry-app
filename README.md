### README.md

---

# Simpe & Easy Poetry Project Setup Script 🚀

Are you tired of the cumbersome process of setting up a new Python project with specific requirements? Look no further! Our shell script automates the entire process, making your life as a developer smoother and more efficient. Introducing the **Ultimate Poetry Project Setup Script**!

---

## Features:

- **Interactive Input Prompts**: Seamlessly enter your project details such as name, author name, email, Python version, and more.
- **Email Validation**: Ensures you enter a valid email format for a professional touch.
- **Flexible Configuration**: Customize virtual environment preferences with a simple yes/no prompt.
- **Automated `pyproject.toml` Generation**: Generates a clean and error-free `pyproject.toml` file tailored to your inputs.
- **Seamless Virtual Environment Activation**: Automatically configures and activates your virtual environment.
- **Perfect for All Projects**: Whether you're starting a small script or a large-scale application, our script scales with your needs.

---

## Why Choose Our Script?

Setting up a Python project with specific requirements can be a hassle. Our script eliminates the guesswork and manual edits, letting you focus on what you do best: coding! Here’s why our script stands out:

- **Time-Saving**: Automates repetitive tasks so you can start coding immediately.
- **Error-Free Setup**: Ensures consistent and correct project configurations every time.
- **User-Friendly**: Designed with developers in mind, it’s simple, intuitive, and effective.
- **Customizable**: Adapts to your project needs, ensuring maximum flexibility.

---

## How to Use:

1. **Clone or Download the Script**: Get the script from this GitHub repository.
2. **Make the Script Executable**:
   ```sh
   chmod +x create-poetry-project
   ```
3. **Run the Script**:
   ```sh
   ./create-poetry-project
   ```
4. **Follow the Prompts**: Enter the required information when prompted.
5. **Start Coding**: Your new Poetry project is ready to go!

---

## Adding create-poetry-app to Your Shell Configuration

To make the `create-poetry-app` script easily accessible from anywhere in your terminal, you can add it to your shell configuration file. This will allow you to run the script from any directory without needing to specify the full path.

#### For macOS and Linux Users:

1. **Move the Script to a Directory in Your PATH**:

   It's common to move scripts to `/usr/local/bin` so they are in your system's PATH. However, depending on your system configuration, you might use a different directory such as `/usr/bin` or another location included in your PATH. You can find out the directories in your PATH by running `echo $PATH` in your terminal.

   Here is a command to move the script to `/usr/local/bin` and make it executable:

   ```sh
   sudo mv create-poetry-app /usr/local/bin/
   sudo chmod +x /usr/local/bin/create-poetry-app
   ```

   If you prefer to use a different directory, replace `/usr/local/bin/` with your preferred directory.

2. **Add to Shell Configuration File**:

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

## Example

```sh
$ ./create-poetry-project

Enter project name (default: projectname):
matrixworld
Enter your project name (default: main):
singularity
Enter Python version (default: 3.12):
3.8
Enter upper Python version limit (default: 4.0):
3.13
Enter project description (default: ):
Project Matrix Multiverse
Enter author name (default: Your Name):
aifirstd3v   
Enter author email (default: you@example.com):
aifirstd3v@universe.8
Invalid email format. Please enter a valid email address.
Enter author email (default: you@example.com):
aifirstd3v@33.universe
Set virtualenvs.in-project to true/false (default: true):

Created package singularity in matrixworld
Creating virtualenv singularity in ~/matrixworld/.venv
Using virtualenv: ~/matrixworld/.venv
Updating dependencies
Resolving dependencies... (0.1s)

Writing lock file

Installing the current project: singularity (0.1.0)
Project 'matrixworld' created and virtual environment activated with Python 3.10
```

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

