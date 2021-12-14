#!/usr/bin/env bash

# https://github.com/UbuntuBudgie/budgie-extras/blob/master/budgie-extras-daemon/src/layouts.vala

main () {

	mkdir -p "$HOME/budgie-schemas/"

	sudo cp -a ./assets/wallpapers/. /usr/share/backgrounds/budgie/
	mkdir -p $HOME/Pictures/wallpapers
	cp -a ./assets/wallpapers/. $HOME/Pictures/wallpapers/

	# Ubuntu Budgie specific
	if [ "$distro" == "ubuntu" ]  && [ "$dename" == "budgie" ];then
		gsettings set org.gnome.desktop.background color-shading-type "solid"
		gsettings set org.gnome.desktop.background picture-options "stretched"
		gsettings set org.gnome.desktop.background picture-uri "file:////usr/share/backgrounds/budgie/sorunme-1920x1200.jpg"
		gsettings set org.gnome.desktop.background primary-color "#008094"
		gsettings set org.ubuntubudgie.plugins.budgie-appmenu enable-powerstrip true
		gsettings set io.elementary.desktop.wingpanel.applications-menu use-category true
		gsettings set org.nemo.window-state start-with-menu-bar true
		gsettings set org.nemo.preferences show-hidden-files true
		gsettings set org.nemo.preferences quick-renames-with-pause-in-between true

		# gsettings set com.solus-project.budgie-panel.instance.appmenu.*.bold-application-name true
		# gsettings set com.solus-project.budgie-panel.panel enable-shadow true
		# gsettings set com.solus-project.budgie-panel.panel size 39
		# gsettings set com.solus-project.budgie-panel.panel transparency "None"
	fi

	# Backup file if needed
	latestBackup="./backups/`ls -A1 ./backups | grep "^25_budgie-desktop-environment" | tail -n1`"
	if [ "$latestBackup" != "./backups/" ];then
		if ! diff -u /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override "$latestBackup" > /dev/null;then
			echo "25_budgie-desktop-environment.gschema.override file differs, will back it up before updating it."
			cp /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override ./backups/25_budgie-desktop-environment.gschema.override.`date "+%y-%m-%d_%H%M%S"`.bak
		fi
	elif [ "$latestBackup" == "./backups/" ];then
		echo "Creating 1st backup"
		cp /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override ./backups/25_budgie-desktop-environment.gschema.override.`date "+%y-%m-%d_%H%M%S"`.bak
	fi
	# End backup

	# Backup file if needed
	latestBackup="./backups/`ls -A1 ./backups | grep "^org\.valapanel\.appmenu" | tail -n1`"
	if [ "$latestBackup" != "./backups/" ];then
		if ! diff -u /usr/share/glib-2.0/schemas/org.valapanel.appmenu.gschema.xml "$latestBackup" > /dev/null;then
			echo "org.valapanel.appmenu.gschema.xml file differs, will back it up before updating it."
			cp /usr/share/glib-2.0/schemas/org.valapanel.appmenu.gschema.xml ./backups/org.valapanel.appmenu.gschema.xml.`date "+%y-%m-%d_%H%M%S"`.bak
		fi
	elif [ "$latestBackup" == "./backups/" ];then
		echo "Creating 1st backup"
		cp /usr/share/glib-2.0/schemas/org.valapanel.appmenu.gschema.xml ./backups/org.valapanel.appmenu.gschema.xml.`date "+%y-%m-%d_%H%M%S"`.bak
	fi
	# End backup

	# Backup file if needed
	latestBackup="./backups/`ls -A1 ./backups | grep "^cupertino\.layout" | tail -n1`"
	if [ "$latestBackup" != "./backups/" ];then
		if ! diff -u /usr/share/budgie-desktop/layouts/cupertino.layout "$latestBackup" > /dev/null;then
			echo "cupertino.layout file differs, will back it up before updating it."
			cp /usr/share/budgie-desktop/layouts/cupertino.layout ./backups/cupertino.layout.`date "+%y-%m-%d_%H%M%S"`.bak
		fi
	elif [ "$latestBackup" == "./backups/" ];then
		echo "Creating 1st backup"
		cp /usr/share/budgie-desktop/layouts/cupertino.layout ./backups/cupertino.layout.`date "+%y-%m-%d_%H%M%S"`.xml.bak
	fi
	# End backup

	# if [ -d /tmp/sorun ] && [ -f /tmp/sorun/assets/25_budgie-desktop-environment.gschema.override ];then
	# 	sudo cp /tmp/sorun/assets/25_budgie-desktop-environment.gschema.override /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override
	if [ -d ./assets/ ];then
		sudo cp ./assets/icons/scalable/sorunme-symbolic.svg /usr/share/icons/hicolor/scalable/apps/sorunme-symbolic.svg
		sudo cp ./assets/25_budgie-desktop-environment.gschema.override /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override
		sudo cp ./assets/org.valapanel.appmenu.gschema.xml /usr/share/glib-2.0/schemas/org.valapanel.appmenu.gschema.xml
		sudo cp ./assets/cupertino.layout /usr/share/budgie-desktop/layouts/cupertino.layout
	fi
	sudo glib-compile-schemas /usr/share/glib-2.0/schemas
	gsettings set com.github.danielpinto8zz6.budgie-calendar-applet custom-format '%a %b %e %l:%M %p'
	nohup budgie-panel --reset --replace &

	}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"
