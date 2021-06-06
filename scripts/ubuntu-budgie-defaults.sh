#!/usr/bin/env bash

mkdir -p "$HOME/budgie-schemas/"

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
	sudo cp ./assets/25_budgie-desktop-environment.gschema.override /usr/share/glib-2.0/schemas/25_budgie-desktop-environment.gschema.override
	sudo cp ./assets/org.valapanel.appmenu.gschema.xml /usr/share/glib-2.0/schemas/org.valapanel.appmenu.gschema.xml
	sudo cp ./assets/cupertino.layout /usr/share/budgie-desktop/layouts/cupertino.layout
fi
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

nohup budgie-panel --reset --replace &