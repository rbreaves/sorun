#!/usr/bin/env bash



main() {
	# title="openssh-config.sh"
	# canary=false

	# unconfirmed=true
	# question='Would you like install & enable openssh-server?'
	# choices=(*yes no)
	# response=$(prompt "$question" $choices)
	
	# if [ "$response" == "y" ];then
	# 	while $unconfirmed; do
	# 		while [ $(isnum "$port") -eq 0 ]; do
	# 			read -rep "${BWHITE}Port (Default 22): ${NC}" port
	# 			if [ -z "$port" ]; then
	# 				port="22"
	# 			fi
	# 		done
	# 		question="Just to confirm you want port $port?"
	# 		choices=(*yes no)
	# 		response=$(prompt "$question" $choices)
	# 		if [ "$response" == "n" ];then
	# 			unset port
	# 		else
	# 			unconfirmed=false
	# 		fi
	# 	done
	# else
	# 	exit 0
	# fi

	# question='Would you like to check the status & set your ufw firewall exception?'
	# choices=(*yes no)
	# response=$(prompt "$question" $choices)
	# if [ "$response" == "y" ];then
	# 	echo "We will set port $port to be allowed. You may be prompted for password."
	# 	sudo ufw allow $port
	# 	if [ $? -eq 0 ]; then
	# 		echo "${BGREEN}Port $port was successfully added or already part of ufw!${NC}"
	# 	else
	# 		echo "${BRED}Port was not added to ufw! :/${NC}"
	# 		canary=true
	# 	fi
	# 	echo "Checking status of ufw firewall..."
	# 	sudo ufw status | grep -qw active
	# 	if [ $? -eq 1 ]; then
	# 		echo "Firewall is disabled."
	# 		echo "Enabling now..."
	# 		sudo ufw enable
	# 		if [ $? -eq 0 ]; then
	# 			echo "${BGREEN}Firewall is enabled!${NC}"
	# 		else
	# 			echo "${BRED}Firewall failed to enable! :/${NC}"
	# 			canary=true
	# 		fi
	# 	else
	# 		echo "${BGREEN}Firewall is already enabled!${NC}"
	# 	fi
	# fi
	exit 1
}

# source ./functions/colors.sh
# source ./functions/prompt.sh

main "$@"; exit 1