#!/usr/bin/env bash

main() {
	dead_canary=0

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

		success="Port $port was successfully added or already part of ufw!"
		failure="Port was not added to ufw! :/"
		sudo ufw allow $port
		canary $? "$success" "$failure"
		dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))

		success="Firewall is already enabled!"
		failure="Firewall is disabled.\nEnabling now..."
		echo "Checking status of ufw firewall..."	
		sudo ufw status | grep -qw active
		canary $? "$success" "$failure"
		if [ $? -eq 1 ]; then
			success="Firewall is enabled!"
			failure="Firewall failed to enable! :/"
			sudo ufw enable
			canary $? "$success" "$failure"
			dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))
		fi
	fi

	# TODO - Add in detection for proper package manager
	running "Now installing openssh-server & client..."
	success="Success! OpenSSH Server & Client is installed."
	failure="Failure! OpenSSH Server & Client did not install."
	sudo apt install -y openssh-server openssh-client
	canary $? "$success" "$failure"
	dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))

	running "Verifying that the SSH service is running..."
	success="SSH Service is running."
	failure="SSH Service is not running.\nWill enable."
	systemctl is-active sshd >/dev/null 2>&1
	canary $? "$success" "$failure"
	dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))
	ssh_path="$HOME/.ssh"
	ssh_filename="id_rsa"
	running "Checking for SSH key pairs existence ($ssh_path/$ssh_filename & $ssh_path/$ssh_filename.pub)..."
	success="Key pairs detected. Good to go."
	failure="Key pairs not found."
	test -f "$ssh_path/$ssh_filename" && test -f "$ssh_path/$ssh_filename.pub"
	canary $? "$success" "$failure"
	if [ $? -eq 1 ]; then
		set_ssh=1
		while [ $set_ssh -eq 1 ]; do
			echo -e "\nWhat would you like to do?\n\n${BGREEN}1) Create a new key-pair${NC}\n2) Cancel\n"
			# \n2) Change your key-pair path to an existing key
			question=""
			choices=("*1" 2 3)
			response=$(prompt "$question" "$choices")
			if [ "$response" == "1" ];then
				success="Key-pair created successfully."
				failure="Key-pair failed to be created."
				ssh-keygen -b 4096
				# test -f "$ssh_path/$ssh_filename"
				canary $? "$success" "$failure"
				set_ssh=$(echo $?)
			# elif [ "$response" == "2" ];then
			# 	echo "Listing files (if any) in ~/.ssh"
			# 	find ~/.ssh -printf "%20.20f %0.20u:%0.20g %5.4m %11.11M %0.30p\n"
			# 	change_ssh=1
			# 	while [ $change_ssh -eq 1 ]; do
			# 		read -rep "${BWHITE}Please set your private key filename [Default id_rsa]:${NC}" ssh_filename
			# 		if [ -z "$ssh_filename" ]; then
			# 			ssh_filename="id_rsa"
			# 		fi
			# 		read -rep "${BWHITE}Please set your full path [Default $HOME/.ssh]:${NC}" ssh_path
			# 		if [ -z "$ssh_path" ]; then
			# 			ssh_path="$HOME/.ssh"
			# 		fi
			# 		success="Found new key-pair."
			# 		failure="Location: $ssh_path/$ssh_filename\nFailed to find new key-pair. Try again."
			# 		test -f "$ssh_path/$ssh_filename"
			# 		canary $? "$success" "$failure"
			# 		# if [ $? -eq 0 ]; then
			# 			# Update ~/.ssh/config
			# 			# Host *
			# 			# 	IdentityFile /path/to/key.file
			# 		# fi
			# 		change_ssh=$(echo $?)
			# 	done
			else
				exit 0
			fi
		done
	fi

	# running "Disable password authentication? Key pairs only will be accepted."
	allow_users=$(awk '/AllowUsers (.*)/ { $1="";sub(/^[ \t]+/, "");print }' /etc/ssh/sshd_config)
	success="AllowUsers $allow_users already found in sshd_config. Skipping."
	failure="AllowUsers not found in sshd_config."
	canary $? "$success" "$failure"
	if [ $? -eq 1 ]; then

		question="Which users should be allowed to use SSH? Default[ `whoami` ] (add a space btwn each user):"
		read -rep "${BWHITE}$question ${NC}" allow_users
		if [ -z "$allow_users" ]; then
			allow_users=$(whoami)
		fi
		success="Added $allower_users to AllowUsers."
		failure="Failed to add $allower_users to AllowUsers."
		echo "AllowUsers $allow_users" | sudo tee -a /etc/ssh/sshd_config
		canary $? "$success" "$failure"
	fi


	if $dead_canary; then
		exit 1
	else
		sudo systemd restart ssh
		exit 0
	fi
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"