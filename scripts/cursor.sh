#!/usr/bin/env bash

main() {

    # Install nicer cursors
    wget -qO macOSMonterey.tar.gz https://github.com/ful1e5/apple_cursor/releases/latest/download/macOSMonterey.tar.gz
    tar -xvf macOSMonterey.tar.gz
    mkdir -p ~/.icons
    mv macOSMonterey ~/.icons/

    # Set accessibility cursor size to medium (one size up)
    # Reset mouse theme (tweaks) to macOSMonterey

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

