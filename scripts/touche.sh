#!/usr/bin/env bash

main() {
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install flathub com.github.joseexposito.touche
    flatpak override --user --env=GTK_THEME=Adwaita-dark
    # Force overwite
    yes | cp -rf ./assets/config/touchegg/ ~/.config/
    sudo systemctl restart touchegg
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"

