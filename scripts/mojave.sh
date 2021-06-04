#!/usr/bin/env bash

main () {
	# defaults being set elsewhere
	# gsettings set com.solus-project.budgie-panel dark-theme true

	# DE types budgie|gnome|KDE|KDE|unity|xfce|cinnamon|mate|lxde|sugar|unknown

	# Debian/Ubunutu/Pop!_OS
	if [ "$distro" == "debian" ]  || [ "$distro" == "ubuntu" ]  || [ "$distro" == "pop!_os" ];then
		mojaveQuery=`dpkg-query -l | grep "mojave\|fonts\-roboto" | wc -l`
		if [ $mojaveQuery -lt 4 ]; then
			sudo add-apt-repository --yes ppa:ubuntubudgie/backports
			sudo apt-get update
			sudo apt-get $apt_quiet -y install mojave-gtk-theme mcmojave-circle fonts-roboto
		else
			echo "Already installed mojave ppa:ubuntubudgie/backports. Skipping."
		fi
	fi

	# Budgie Only
	if [ "$dename" == "budgie" ];then
		gsettings set com.solus-project.budgie-wm button-style 'left'
		gsettings set com.solus-project.budgie-panel dark-theme true
		gsettings set com.solus-project.budgie-panel layout 'cupertino'
		gsettings set com.solus-project.budgie-panel builtin-theme false
	# Gnome Only
	elif [ "$dename" == "gnome" ];then
		echo ""
	fi

	# Budgie/Gnome
	if [ "$dename" == "budgie" ] || [ "$dename" == "gnome" ];then
		gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
		gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"

		gsettings set org.gnome.desktop.interface cursor-theme "DMZ-Black"
		gsettings set org.gnome.desktop.interface gtk-theme "Mojave-dark"
		gsettings set org.gnome.desktop.interface icon-theme "McMojave-circle-dark"
		gsettings set org.gnome.desktop.interface monospace-font-name "Ubuntu Mono 13"
		gsettings set org.gnome.desktop.interface font-name "Roboto Regular 11"
		gsettings set org.gnome.desktop.interface document-font-name "Roboto Regular 11"

		gsettings set org.gnome.desktop.wm.preferences titlebar-font "Roboto Regular 11"
		gsettings set org.gnome.desktop.wm.preferences theme "Mojave-dark"
		gsettings set org.nemo.desktop font "Roboto Regular 11"

		gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ icon-size "72"
		gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled "false"
		gsettings set io.elementary.desktop.wingpanel.applications-menu enable-powerstrip "true"
	fi

	# Ubuntu Budgie specific
	if [ "$distro" == "ubuntu" ]  && [ "$dename" == "budgie" ];then
		gsettings set org.gnome.desktop.background color-shading-type "solid"
		gsettings set org.gnome.desktop.background picture-options "stretched"
		gsettings set org.gnome.desktop.background picture-uri "file:////usr/share/backgrounds/budgie/mountain-lake_by_william_beckwith.jpg"
		gsettings set org.gnome.desktop.background primary-color "#008094"

		# gsettings set com.solus-project.budgie-panel.instance.appmenu.*.bold-application-name true
		# gsettings set com.solus-project.budgie-panel.panel enable-shadow true
		# gsettings set com.solus-project.budgie-panel.panel size 39
		# gsettings set com.solus-project.budgie-panel.panel transparency "None"
	fi
	
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"