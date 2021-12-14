#!/usr/bin/env bash

main() {

    # Detect users resolution screen size, example
    # Resolution: 2880x1800

    # Ask user: What is the physical size of your screen? e.g. 11.6", 13", 15", etc.

    # Calculate a readable DPI for user.
    # If in or near 2x category then recommend using Gdk 2x scaling
    # Otherwise set ~/.profile
    # e.g.
    #   export GDK_DPI_SCALE=1.3
    #   export QT_SCALE_FACTOR=1.3

    # If Gdk 2x scaling is applied then apply fix for sharp Remmina RDP focus.
    # env GDK_BACKEND="x11" GDK_SCALE=1 CLUTTER_SCALE=1 remmina
    # /usr/share/applications/org.remmina.Remmina.desktop

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

