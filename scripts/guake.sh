#!/usr/bin/env bash

main() {
    gsettings set guake.general gtk-prefer-dark-theme true
    gsettings set guake.general gtk-theme-name 'Mojave-dark'
    gsettings set guake.style cursor-blink-mode 1
    gsettings set guake.style cursor-shape 1
    gsettings set guake.style.background transparency 95
    gsettings set guake.style.font palette-name 'Oceanic Next Dark'
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

