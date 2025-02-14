#!/bin/bash -e

# Function to show usage information
function show_usage {
    echo "Usage: $0 [options] [project_name]"
    echo "Options:"
    echo "  -u USERNAME   Set admin username (default: admin)"
    echo "  -p PASSWORD   Set admin password (default: admin)"
    echo "  -e EMAIL      Set admin email (default: admin@mail.com)"
    echo "  -h            Show this help message"
    echo ""
    echo "Remove installation:"
    echo "  $0 remove [project_name]"
    exit 1
}

# Display help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
fi

clear

# for MAMP user using php version 7.1.1 this is required
# export PATH="/Applications/MAMP/bin/php/php7.1.1/bin:$PATH"

# Default admin credentials
admin_user="admin"
admin_pass="admin"
admin_email="admin@mail.com"

# Parse command line options
while getopts ":u:p:e:h" opt; do
  case $opt in
    u) admin_user="$OPTARG" ;;
    p) admin_pass="$OPTARG" ;;
    e) admin_email="$OPTARG" ;;
    h) show_usage ;;
    \?) echo "Invalid option -$OPTARG" >&2; show_usage ;;
  esac
done

# Move past the options
shift $((OPTIND - 1))

# Remove/Uninstall process
if [[ $1 == "remove" ]]; then
    # Grab the project name
    if [[ -z $2 ]]; then
        echo "WP Project to remove: "
        read -e projectname
    else
        projectname=$2
    fi

    projectDirectory="$projectname"

    if [[ ! -d $projectDirectory ]]; then
        echo "$projectDirectory directory does not exist"
        exit 1
    fi

    wp db drop --yes --path=$projectDirectory

    rm -rf $projectDirectory

    echo "$projectname removed completely"

    exit 0
fi

echo "================================================================="
echo "WordPress Installer!!"
echo "================================================================="

if [ -z "$1" ]; then
    # accept user input for the database name
    echo "Project Name (no spaces): "
    read -e projectname

    # Validate project name
    if [[ $projectname =~ [[:space:]] ]]; then
        echo "Error: Project name cannot contain spaces"
        exit 1
    fi
else
    projectname=$1

    # Validate project name
    if [[ $projectname =~ [[:space:]] ]]; then
        echo "Error: Project name cannot contain spaces"
        exit 1
    fi
fi

mkdir -p "$projectname"
cd "$projectname"

# download the WordPress core files
wp core download

# create the wp-config file with our standard setup
wp core config --dbname=$projectname --dbuser=root --dbpass= --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'SCRIPT_DEBUG', true );
PHP

# create database, and install WordPress
wp db create
wp core install --url="$projectname.test" --title="WordPress Localhost Site" --admin_user="$admin_user" --admin_password="$admin_pass" --admin_email="$admin_email" --skip-email

# discourage search engines
wp option update blog_public 0

# this is required for the .htaccess
touch wp-cli.local.yml
echo "apache_modules:
  - mod_rewrite
" > wp-cli.local.yml

# set pretty urls
wp rewrite structure '/%postname%/' --hard
wp rewrite flush --hard

# set timezone
wp option update timezone_string "Asia/Dhaka"

rm wp-cli.local.yml

# delete akismet and hello dolly
wp plugin delete akismet
wp plugin delete hello

echo "================================================================="
echo "Installation is complete. Open browser: $projectname.test/wp-admin/"
echo "Admin User: $admin_user"
echo "Admin Pass: $admin_pass"
echo "================================================================="
