#!/usr/bin/env bash

# defaults being set elsewhere
# gsettings set com.solus-project.budgie-panel dark-theme true

gsettings set com.solus-project.budgie-wm button-style 'left'
gsettings set com.solus-project.budgie-panel dark-theme true

mojaveQuery=`dpkg-query -l | grep "mojave\|fonts\-roboto" | wc -l`
if [ $mojaveQuery -lt 4 ]; then
	sudo add-apt-repository --yes ppa:ubuntubudgie/backports
	sudo apt-get update
	sudo apt-get -y install mojave-gtk-theme mcmojave-circle fonts-roboto
else
	echo "Already installed. Skipping."
fi

gsettings set com.solus-project.budgie-panel layout 'cupertino'
gsettings set com.solus-project.budgie-panel builtin-theme false
gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"

# gsettings set com.solus-project.budgie-panel.instance.appmenu.*.bold-application-name true
# gsettings set com.solus-project.budgie-panel.panel enable-shadow true
# gsettings set com.solus-project.budgie-panel.panel size 39
# gsettings set com.solus-project.budgie-panel.panel transparency "None"

gsettings set org.gnome.desktop.interface cursor-theme "DMZ-Black"
gsettings set org.gnome.desktop.interface gtk-theme "Mojave-dark"
gsettings set org.gnome.desktop.interface icon-theme "McMojave-circle-dark"
gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono 13"
gsettings set org.gnome.desktop.interface font-name "Roboto Regular 11"
gsettings set org.gnome.desktop.interface document-font-name "Roboto Regular 11"

gsettings set org.gnome.desktop.background color-shading-type "solid"
gsettings set org.gnome.desktop.background picture-options "stretched"
gsettings set org.gnome.desktop.background picture-uri "file:////usr/share/backgrounds/budgie/mountain-lake_by_william_beckwith.jpg"
gsettings set org.gnome.desktop.background primary-color "#008094"

gsettings set org.gnome.desktop.wm.preferences titlebar-font "Roboto Regular 11"
gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"
gsettings set org.nemo.desktop font "Roboto Regular 11"

gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ icon-size "72"
gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled "false"
gsettings set io.elementary.desktop.wingpanel.applications-menu enable-powerstrip "true"
