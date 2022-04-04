#!/usr/bin/env bash

main() {

    # Match checking product name
    # Apply specific settings & changes to tweak touchpad or other hardware
    # specific to the device.
    
    # enable hw acceleration for chrome
    sudo apt install intel-media-va-driver-non-free libva-drm2 libva-x11-2

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

