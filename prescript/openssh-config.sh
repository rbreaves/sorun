#!/usr/bin/env bash



main() {
	dead_canary=false

	unconfirmed=true
	question='Would you like install & enable openssh-server?'
	choices=(*yes no)
	response=$(prompt "$question" $choices)
	
	if [ "$response" == "y" ];then
		while $unconfirmed; do
			while [ $(isnum "$port") -eq 0 ]; do
				read -rep "${BWHITE}Port (Default 22): ${NC}" port
				if [ -z "$port" ]; then
					port="22"
				fi
			done
			question="Just to confirm you want port $port?"
			choices=(*yes no)
			response=$(prompt "$question" $choices)
			if [ "$response" == "n" ];then
				unset port
			else
				unconfirmed=false
			fi
		done
	else
		exit 0
	fi

	question='Would you like to check the status & set your ufw firewall exception?'
	choices=(*yes no)
	response=$(prompt "$question" $choices)
	if [ "$response" == "y" ];then
		echo "We will set port $port to be allowed. You may be prompted for password."
		sudo ufw allow $port
		if [ $? -eq 0 ]; then
			echo "${BGREEN}Port $port was successfully added or already part of ufw!${NC}"
		else
			echo "${BRED}Port was not added to ufw! :/${NC}"
			dead_canary=true
		fi
		echo "Checking status of ufw firewall..."
		sudo ufw status | grep -qw active
		if [ $? -eq 1 ]; then
			echo "Firewall is disabled."
			echo "Enabling now..."
			sudo ufw enable
			if [ $? -eq 0 ]; then
				echo "${BGREEN}Firewall is enabled!${NC}"
			else
				echo "${BRED}Firewall failed to enable! :/${NC}"
				dead_canary=true
			fi
		else
			echo "${BGREEN}Firewall is already enabled!${NC}"
		fi
	fi

	echo "${BYELLOW}Now installing openssh-server & client...${NC}"
	# sudo apt install -y openssh-server openssh-client

	echo "${BYELLOW}Verifying that the SSH service is running...${NC}"
	# sudo systemctl status ssh

	echo "${BYELLOW}Checking for SSH key pairs existence (~/.ssh/id_rsa & id_rsa.pub...${NC}"
	echo "${BGREEN}Key pairs detected. Good to go.${NC}"
	echo "${BRED}Key pairs not found.${NC} ${BYELLOW}Would you like to create them now?${NC}"
	echo "${BYELLOW}Will generate a 4096 bit RSA encrypted key-pair.${NC}"
	# ssh-keygen -b 4096

	echo "${BYELLOW}Disable password authentication? Key pairs only will be accepted.${NC}"
	echo "${BYELLOW}Which users should be allowed to use SSH? Default[ $whoami ] (hit enter to use default):${NC}"


	if $dead_canary; then
		exit 1
	else
		exit 0
	fi
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"