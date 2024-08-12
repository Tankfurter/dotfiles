#!/bin/bash

# Script to install standard applications on Ubuntu

# Array of packages to install
PACKAGES=("tree" "net-tools" "slurm" "python3" "docker.io" "htop" "glances" "ncdu") 

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

# Main installation function
function install_standard_apps() {
    echo "Starting installation of standard applications..."

    # Loop through the array of packages
    for PACKAGE in "${PACKAGES[@]}"; do
        install_package "$PACKAGE" || echo "Warning: $PACKAGE could not be installed."
    done

    echo "Installation of standard applications complete."
    # Output the list of packages that were just installed
    echo "The following packages confirmed installed on the system:"
    for PACKAGE in "${PACKAGES[@]}"; do
        if dpkg -l | grep -q "^ii\s*${PACKAGE}\s"; then
            echo " - $PACKAGE"
        fi
    done
}

# Main script execution
function main() {
    update_system
    install_standard_apps
}

# Call the main function
main
