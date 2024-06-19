import ast
import logging
import subprocess
from importlib.metadata import PackageNotFoundError, distributions, version

# Set up logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)


def get_imported_modules(file_path):
    logging.info(f"Reading file: {file_path}")
    with open(file_path, "r") as file:
        tree = ast.parse(file.read(), filename=file_path)
    imported_modules = set()
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                imported_modules.add(alias.name)
        elif isinstance(node, ast.ImportFrom):
            imported_modules.add(node.module)
    logging.info(f"Imported modules found: {imported_modules}")
    return imported_modules


def get_installed_packages():
    logging.info("Retrieving installed packages")
    installed_packages = {
        dist.metadata["Name"].lower(): dist.metadata["Version"]
        for dist in distributions()
    }
    logging.info(f"Installed packages retrieved: {installed_packages}")
    return installed_packages


def filter_installed_modules(modules, installed_packages):
    logging.info("Filtering imported modules against installed packages")
    filtered_modules = {}
    for module in modules:
        try:
            pkg_version = version(module)
            if module in installed_packages:
                filtered_modules[module] = pkg_version
                logging.info(f"Module {module} with version {pkg_version} is installed")
        except PackageNotFoundError:
            logging.warning(f"Module {module} not found in installed packages")
            continue
    logging.info(f"Filtered modules: {filtered_modules}")
    return filtered_modules


def write_requirements_file(modules, file_path="requirements.txt"):
    logging.info(f"Writing requirements to {file_path}")
    with open(file_path, "w") as req_file:
        for module, version in modules.items():
            req_file.write(f"{module}=={version}\n")
            logging.info(f"Added {module}=={version} to {file_path}")


if __name__ == "__main__":
    file_path = "create_poetry_app.py"
    logging.info("Starting the requirements generation process")
    imported_modules = get_imported_modules(file_path)
    installed_packages = get_installed_packages()
    filtered_modules = filter_installed_modules(imported_modules, installed_packages)
    write_requirements_file(filtered_modules)
    logging.info(f"requirements.txt file has been generated based on {file_path}")
