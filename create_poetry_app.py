import logging
import os
import re
import subprocess
from argparse import ArgumentParser

import toml

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_user_shell():
    user_shell = os.environ.get("SHELL", "/bin/bash")
    logging.debug(f"user_shell: {user_shell}")

    return user_shell


USER_SHELL = get_user_shell()


class ProjectCreator:
    """
    ProjectCreator is a utility class that automates the creation of new Python projects using Poetry.
    """

    def __init__(self):
        self.DEFAULT_PROJECT_NAME = "projectname"
        self.DEFAULT_MY_NAME = "main"
        self.DEFAULT_PYTHON_VERSION = "^3.12"
        self.DEFAULT_VENV_CONFIG = "true"
        self.DEFAULT_DESCRIPTION = "description"
        self.DEFAULT_AUTHOR_NAME = "Your Name"
        self.DEFAULT_AUTHOR_EMAIL = "you@example.com"

        self.project_name = ""
        self.my_name = ""
        self.python_version = ""
        self.upper_python_version = ""
        self.venv_config = ""
        self.description = ""
        self.author_name = ""
        self.author_email = ""
        self.use_defaults = False
        self.dependency_version = ""
        self.template = ""
        self.dependencies = {}

        self.new_virtual_env_path = ""
        self.activate_script = ""

    def validate_email(self, email):
        return bool(
            re.match(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$", email)
        )

    def clean_upper_version(self, version):
        if not version:
            return ""
        cleaned_version = re.sub(r"[^0-9.]", "", version)
        if re.match(r"^[0-9]+\.[0-9]+(\.[0-9]+)?$", cleaned_version):
            return cleaned_version
        else:
            raise ValueError(
                "Invalid upper Python version format. It should be in the format x.y.z."
            )

    def convert_package_name(self, name):
        return name.replace("-", "_")

    def sanitize_input(self, input_value):
        return re.sub(r"[^0-9.]", "", input_value)

    def parse_options(self):
        parser = ArgumentParser(description="Create a new Python project using Poetry.")
        parser.add_argument("-y", action="store_true", help="Use default values")
        parser.add_argument("-p", type=str, help="Project name")
        parser.add_argument("-n", type=str, help="Package name")
        parser.add_argument("-v", type=str, help="Python version")
        parser.add_argument("-u", type=str, help="Upper Python version limit")
        parser.add_argument("-d", type=str, help="Project description")
        parser.add_argument("-a", type=str, help="Author name")
        parser.add_argument("-e", type=str, help="Author email")
        parser.add_argument("-c", type=str, help="Virtualenv configuration")
        parser.add_argument("-t", type=str, help="Project template")
        args = parser.parse_args()
        self.use_defaults = args.y
        self.project_name = args.p
        self.my_name = args.n
        self.python_version = args.v
        self.upper_python_version = args.u
        self.description = args.d
        self.author_name = args.a
        self.author_email = args.e
        self.venv_config = args.c
        self.template = args.t

    def load_template_dependencies(self):
        if self.template:
            config_path = os.path.join(
                os.path.expanduser("~"), ".create-poetry-app", "config.toml"
            )
            print(f"Loading config from: {config_path}")
            config = toml.load(config_path)
            print(f"config.toml: {config}")
            try:
                self.dependencies = config["template"]["dependency"][self.template]
            except KeyError:
                raise ValueError(f"Template '{self.template}' not found in config.toml")

    def prompt_for_inputs(self):
        if not self.project_name:
            self.project_name = (
                input(f"Enter project name (default: {self.DEFAULT_PROJECT_NAME}): ")
                or self.DEFAULT_PROJECT_NAME
            )

        if not self.template:
            self.template = input(
                "Enter project template (optional, e.g., datascience, ai): "
            )
            self.load_template_dependencies()

        if not self.use_defaults:
            if not self.my_name:
                self.my_name = (
                    input(
                        f"Enter your package name (default: {self.DEFAULT_MY_NAME}): "
                    )
                    or self.DEFAULT_MY_NAME
                )
            self.my_name = self.convert_package_name(self.my_name)

            if not self.python_version:
                self.python_version = (
                    input(
                        f"Enter Python version (default: {self.DEFAULT_PYTHON_VERSION}, e.g., 3.12 or ^3.12 or ~3.12): "
                    )
                    or self.DEFAULT_PYTHON_VERSION
                )

            if not self.upper_python_version:
                self.upper_python_version = self.clean_upper_version(
                    input(
                        "Enter upper Python version limit (optional, numbers only, e.g., 3.33): "
                    )
                )

            if not self.description:
                self.description = (
                    input(
                        f"Enter project description (default: {self.DEFAULT_DESCRIPTION}): "
                    )
                    or self.DEFAULT_DESCRIPTION
                )

            if not self.author_name:
                self.author_name = (
                    input(f"Enter author name (default: {self.DEFAULT_AUTHOR_NAME}): ")
                    or self.DEFAULT_AUTHOR_NAME
                )

            while not self.author_email:
                self.author_email = (
                    input(
                        f"Enter author email (default: {self.DEFAULT_AUTHOR_EMAIL}): "
                    )
                    or self.DEFAULT_AUTHOR_EMAIL
                )
                if not self.validate_email(self.author_email):
                    print("Invalid email format. Please enter a valid email address.")
                    self.author_email = ""

            if not self.venv_config:
                self.venv_config = (
                    input(
                        f"Set virtualenvs.in-project to true/false (default: {self.DEFAULT_VENV_CONFIG}): "
                    )
                    or self.DEFAULT_VENV_CONFIG
                )

        else:
            self.my_name = self.DEFAULT_MY_NAME
            self.python_version = self.DEFAULT_PYTHON_VERSION
            self.upper_python_version = ""
            self.author_name = self.DEFAULT_AUTHOR_NAME
            self.author_email = self.DEFAULT_AUTHOR_EMAIL
            self.venv_config = self.DEFAULT_VENV_CONFIG
            self.template = ""
            self.dependencies = {}

    def set_dependency_version(self):
        if self.upper_python_version:
            self.dependency_version = f">={self.sanitize_input(self.python_version)},<{self.clean_upper_version(self.upper_python_version)}"
        else:
            if re.match(r"^[^0-9]", self.python_version):
                self.dependency_version = self.python_version
            else:
                self.dependency_version = f"^{self.python_version}"

    def create_pyproject_toml(self):
        author = f"{self.author_name} <{self.author_email}>"
        with open("pyproject.toml", "w") as f:
            f.write(
                f"[tool.poetry]\n"
                f'name = "{self.my_name}"\n'
                f'version = "0.1.0"\n'
                f'description = "{self.description}"\n'
                f'authors = ["{author}"]\n'
                f'readme = "README.md"\n'
                f'packages = [{{include = "{self.my_name}", from = "src"}}]\n\n'
                f"[tool.poetry.dependencies]\n"
                f'python = "{self.dependency_version}"\n'
            )
            for package, version in self.dependencies.items():
                f.write(f'{package} = "{version}"\n')

            f.write(
                "\n[build-system]\n"
                'requires = ["poetry-core"]\n'
                'build-backend = "poetry.core.masonry.api"\n'
            )

    def create_project(self):
        if os.path.exists(self.project_name) and os.listdir(self.project_name):
            print(f"Destination {self.project_name} exists and is not empty.")
            response = input(
                "Do you want to remove the existing directory and continue? [y/N] "
            )
            if response.lower() in ["y", "yes"]:
                subprocess.run(["rm", "-rf", self.project_name], check=True)
                print(f"Removed existing directory {self.project_name}.")
            else:
                print("Operation aborted.")
                exit(1)

        subprocess.run(
            ["poetry", "new", self.project_name, "--name", self.my_name, "--src"],
            check=True,
        )

    def configure_poetry(self):
        subprocess.run(
            ["poetry", "config", "virtualenvs.in-project", self.venv_config], check=True
        )

    def use_python_version(self):
        escaped_python_version = self.sanitize_input(self.python_version)
        print(f"Using Python {escaped_python_version} for poetry env use")

        # Check if a virtual environment is currently active
        virtual_env = os.environ.get("VIRTUAL_ENV")
        logging.debug(f"VIRTUAL_ENV: {virtual_env}")
        if virtual_env:
            print(f"Deactivating current virtual environment at {virtual_env}")
            # Deactivating by unsetting VIRTUAL_ENV and other related environment variables
            os.environ.pop("VIRTUAL_ENV", None)
            os.environ.pop("PYTHONHOME", None)
            os.environ.pop("PYTHONPATH", None)
            # If you are using conda, you might want to deactivate conda environment
            if "CONDA_DEFAULT_ENV" in os.environ:
                try:
                    subprocess.run(
                        ["conda", "deactivate"],
                        shell=True,
                        executable=USER_SHELL,
                        check=True,
                    )
                except subprocess.CalledProcessError:
                    print("Failed to deactivate the existing conda environment.")

        try:
            # Check if the specified Python version is available in the system PATH
            result = subprocess.run(
                ["which", f"python{escaped_python_version}"],
                capture_output=True,
                text=True,
            )
            logging.debug(f"Command output: {result.stdout.strip()}")
            logging.debug(f"Command error: {result.stderr.strip()}")
            logging.debug(f"Command return code: {result.returncode}")

            if result.returncode == 0 and result.stdout.strip():
                python_path = result.stdout.strip()
                print(f"Found Python version at: {python_path}")
                subprocess.run(
                    ["poetry", "env", "use", python_path],
                    check=True,
                )

                # Get the path to the new virtual environment
                result = subprocess.run(
                    ["poetry", "env", "info", "--path"],
                    capture_output=True,
                    text=True,
                    check=True,
                )
                self.new_virtual_env_path = result.stdout.strip()
                print(
                    f"New virtual environment created at: {self.new_virtual_env_path}"
                )
                os.environ["VIRTUAL_ENV"] = self.new_virtual_env_path

                # Manually source the activate script to make sure the shell is aware of the new environment
                self.activate_script = os.path.join(
                    self.new_virtual_env_path, "bin", "activate"
                )

                return
        except subprocess.CalledProcessError:
            print(
                f"Python {escaped_python_version} is not available in the system PATH."
            )

        print(
            f"Error: Python {escaped_python_version} is not available. Please install it using your preferred Python version management tool."
        )

    def install_dependencies(self):
        print("Installing dependencies using poetry")
        subprocess.run(["poetry", "install"], check=True)

        if self.venv_config.lower() == "true":
            venv_path = os.path.abspath(".venv")
            venv_activate_path = os.path.join(venv_path, "bin", "activate")

            logging.debug(f"venv_path: {venv_path}")
            logging.debug(f"venv_activate_path: {venv_activate_path}")
            logging.debug(f"os.path.exists(venv_path): {os.path.exists(venv_path)}")
            logging.debug(
                f"os.path.exists(venv_activate_path): {os.path.exists(venv_activate_path)}"
            )

            if os.path.exists(venv_activate_path):
                print(f"Virtual environment created at {venv_path}")
                print("\033[1;32m" + "=" * 50 + "\033[0m")
                print(
                    "\033[1;32m"
                    + "Virtual environment created successfully!"
                    + "\033[0m"
                )
                print("\033[1;32m" + "=" * 50 + "\033[0m")
                print(
                    "\033[1;34m"
                    + "To activate the virtual environment, run:\n"
                    + "\033[0m"
                )
                print("\033[1;33m" + "source .venv/bin/activate" + "\033[0m")
                print("\033[1;34m" + "or" + "\033[0m")
                print("\033[1;33m" + f"source {self.activate_script}" + "\033[0m")
                print("\033[1;32m" + "=" * 50 + "\033[0m")
            else:
                print(
                    f"Virtual environment activation script not found at {venv_activate_path}"
                )

    def main(self):
        self.parse_options()
        self.prompt_for_inputs()
        self.set_dependency_version()
        self.create_project()
        os.chdir(self.project_name)
        self.create_pyproject_toml()
        print("Generated pyproject.toml:")
        with open("pyproject.toml") as f:
            print(f.read())
        self.configure_poetry()
        self.use_python_version()
        self.install_dependencies()
        print(
            f"⭐️ Congratulations! Project '{self.project_name}' successfully created 👍"
        )


if __name__ == "__main__":
    creator = ProjectCreator()
    creator.main()
