#!/bin/bash

# Script to install categorized applications on Ubuntu

# Arrays of packages to install
DEFAULT_PACKAGES=("tree" "net-tools" "htop" "glances" "ncdu")
QOL_PACKAGES=("python3 "slurm"")  # Quality of Life packages (none currently, but can be added here)
FULL_PACKAGES=("docker.io")  # Full setup packages

# Function to update and upgrade the system
function update_system() {
    echo "Updating system..."
    if ! sudo apt update -y; then
        echo "Error: Failed to update package lists."
        exit 1
    fi

    if ! sudo apt upgrade -y; then
        echo "Error: Failed to upgrade packages."
        exit 1
    fi

    echo "System update complete."
}

# Function to install a package if not already installed
function install_package() {
    PACKAGE_NAME=$1
    if ! dpkg -l | grep -q "^ii\s*${PACKAGE_NAME}\s"; then
        echo "Installing ${PACKAGE_NAME}..."
        if ! sudo apt install -y $PACKAGE_NAME; then
            echo "Error: Failed to install ${PACKAGE_NAME}. Package may not be available."
            return 1
        fi
        echo "${PACKAGE_NAME} installed successfully."
    else
        echo "${PACKAGE_NAME} is already installed."
    fi
}

# Function to install a category of packages
function install_packages() {
    CATEGORY=$1
    PACKAGES=("${!2}")
    
    echo "Starting installation of ${CATEGORY} packages..."
    
    for PACKAGE in "${PACKAGES[@]}"; do
        install_package "$PACKAGE" || echo "Warning: $PACKAGE could not be installed."
    done

    echo "Installation of ${CATEGORY} packages complete."
    echo "The following ${CATEGORY} packages are confirmed installed on the system:"
    for PACKAGE in "${PACKAGES[@]}"; do
        if dpkg -l | grep -q "^ii\s*${PACKAGE}\s"; then
            echo " - $PACKAGE"
        fi
    done
}

# Function to display the menu and get user choice
function display_menu() {
    echo "Select installation option:"
    echo "1. Default"
    echo "2. Quality of Life (includes Default)"
    echo "3. Full (includes Default and Quality of Life)"
    read -p "Enter your choice (1-3): " CHOICE
    
    case $CHOICE in
        1)
            echo "You chose Default."
            install_packages "Default" DEFAULT_PACKAGES[@]
            ;;
        2)
            echo "You chose Quality of Life."
            install_packages "Default" DEFAULT_PACKAGES[@]
            install_packages "Quality of Life" QOL_PACKAGES[@]
            ;;
        3)
            echo "You chose Full."
            install_packages "Default" DEFAULT_PACKAGES[@]
            install_packages "Quality of Life" QOL_PACKAGES[@]
            install_packages "Full" FULL_PACKAGES[@]
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

# Main script execution
function main() {
    update_system
    display_menu
}

# Call the main function
main
