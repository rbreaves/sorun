#!/usr/bin/env bash

main () {

	echo -e "Setup git-projects..."
	mkdir -p ~/Documents/git-projects
	cd ~/Documents/git-projects

	if ! [ -d ~/Documents/git-projects/kinto ];then
		git clone https://github.com/rbreaves/kinto.git
	else
		echo "Kinto repo already exists."
	fi
	if ! [ -d ~/Documents/git-projects/sorun ];then
		git clone https://github.com/rbreaves/sorun.git
	else
		echo -e "Sorun.me repo already exists."
	fi

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"
