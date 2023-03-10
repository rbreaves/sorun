#!/usr/bin/env bash

main() {

    # Install nicer cursors
    wget -qO macOS-Monterey.tar.gz https://github.com/ful1e5/apple_cursor/releases/latest/download/macOS-Monterey.tar.gz
    tar -xvf macOS-Monterey.tar.gz
    mkdir -p ~/.icons
    mv macOS-Monterey ~/.icons/

    # Sets cursor to 2nd smallest setting
    gsettings set org.gnome.desktop.interface cursor-size 32
    # Sets cursor as default
    gsettings set org.gnome.desktop.interface cursor-theme 'macOS-Monterey'

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

