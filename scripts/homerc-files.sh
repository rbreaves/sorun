#!/usr/bin/env bash

file="$HOME/.vimrc"

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

# Check each line and add if needed
cat ./assets/.vimrc | while read line || [[ -n $line ]];
do
	grep -qF -- "$line" "$file" || echo "$line" >> "$file"
done