#!/usr/bin/env bash

main () {
	dead_canary=0

	file="$HOME/.vimrc"
	sudo_file="/root/.vimrc"

	mkdir -p ~/backups

	# Backup file if needed
	latestBackup="./backups/`ls -A1 ./backups | grep "^.vimrc" | tail -n1`"
	if [ -f ~/.vimrc ] && [ "$latestBackup" != "./backups/" ];then
		if ! diff -u ~/.vimrc "$latestBackup" > /dev/null;then
			echo "~/.vimrc file differs, will back it up before updating it."
			cp "$file" ./backups/.vimrc.`date "+%y-%m-%d_%H%M%S"`.bak
		fi
	elif [ -f ~/.vimrc ];then
		echo "Creating 1st backup"
		cp "$file" ./backups/.vimrc.`date "+%y-%m-%d_%H%M%S"`.bak
	fi
	# End backup

	# Check each sudo line and add if needed
	if [ -f ~/.vimrc ];then
		cat ./assets/.vimrc | while read line || [[ -n $line ]];
		do
			grep -qF -- "$line" "$file" || echo "$line" >> "$file"
		done
	else
		cp ./assets/.vimrc ~/.vimrc
	fi

	file="$HOME/.profile"
	# Check each sudo line and add if needed
	if [ -f ~/.profile ];then
		cat ./assets/.profile | while read line || [[ -n $line ]];
		do
			grep -qF -- "$line" "$file" || echo "$line" >> "$file"
		done
	fi

	question="Would you like to copy a basic .vimrc file from $HOME to /root/.vimrc to resolve arrow key & insert issues?"
	choices=(*yes no)
	response=$(prompt "$question" $choices)
	if [ "$response" == "y" ];then
		sudo mkdir -p /root/backups
		sudo cp /root/.vimrc /root/backups/.vimrc.`date "+%y-%m-%d_%H%M%S"`.bak >/dev/null 2>&1
		success=".vimrc copied to root successfully."
		failure=".vimrc failed to copy to root."
		sudo cp $HOME/.vimrc /root/.vimrc >/dev/null 2>&1
		canary $? "$success" "$failure"
		dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))
	fi

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"