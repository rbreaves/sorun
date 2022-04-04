#!/usr/bin/env bash

main() {

    # Install nicer cursors
    wget -qO macOSMonterey.tar.gz https://github.com/ful1e5/apple_cursor/releases/latest/download/macOSMonterey.tar.gz
    tar -xvf macOSMonterey.tar.gz
    mkdir -p ~/.icons
    mv macOSMonterey ~/.icons/

    # Sets cursor to 2nd smallest setting
    gsettings set org.gnome.desktop.interface cursor-size 32
    # Sets cursor as default
    gsettings set org.gnome.desktop.interface cursor-theme 'macOSMonterey'

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

