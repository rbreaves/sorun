#!/usr/bin/env bash

source ./functions/colors.sh

main() {
	gituserconfig=`git config --list | grep user | wc -l`
	if [ $gituserconfig -lt 2 ];then
		question='Would you like to setup your git Name and Email now (globally)?'
		choices=(*yes no)
		response=$(prompt "$question" $choices)
		
		if [ "$response" == "y" ];then
			read -rep "${BWHITE}First & Last Name: ${NC}" name
			read -rep "${BWHITE}Email: ${NC}" email
		else
			exit 0
		fi
		git config --global user.name "$name"
		git config --global user.email "$email"
	fi
}

source ./functions/prompt.sh

main "$@"; exit