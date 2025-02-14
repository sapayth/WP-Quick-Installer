# WP Quick Installer
This Bash script automates the installation and removal of a local WordPress project using WP-CLI. It sets up a WordPress installation with predefined admin credentials and necessary configurations.

## Prerequisites
Ensure you have the following installed before using the script:
- [WP-CLI](https://wp-cli.org/)
- PHP
- MySQL (or a compatible database server)
- Apache or Nginx server

## Usage

### Install a WordPress Project
```sh
./install.sh [options] [project_name]
```

### Options
| Option | Description | Default |
|--------|-------------|---------|
| `-u USERNAME` | Set admin username | `admin` |
| `-p PASSWORD` | Set admin password | `admin` |
| `-e EMAIL` | Set admin email | `admin@mail.com` |
| `-h` | Show help message | - |

### Example Installation
```sh
./install.sh -u myadmin -p mypassword -e myemail@example.com myproject
```
If `project_name` is not provided, the script will prompt for one.

## Remove a WordPress Project
To completely remove an installed WordPress project:
```sh
./install.sh remove [project_name]
```
If `project_name` is not provided, the script will prompt for one.

## Features
- Downloads and installs the latest WordPress core.
- Configures `wp-config.php` with debugging enabled.
- Creates and sets up the database.
- Installs WordPress with specified admin credentials.
- Updates permalink structure to `/%postname%/`.
- Disables search engine indexing.
- Sets the timezone to `Asia/Dhaka`.
- Removes default plugins (`Akismet` and `Hello Dolly`).
- Ensures Apache's `mod_rewrite` is enabled.

## Notes
- The script assumes a local development environment with MySQL user `root` and no password.
- Ensure that WP-CLI is accessible from the command line.
- Running this script with `remove` will **permanently delete** the WordPress directory and its database.

## License
This script is open-source and available for modification and use.

