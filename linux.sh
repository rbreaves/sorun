#!/usr/bin/env bash


apt_quiet="-qq"

# Checks to see if running from the web or locally
# will download for a local install if ran remotely
if [ "$1" == "--dev" ];then
	echo "Entered Dev Branch Mode"
	if ! [[ -d "./configs" ]]; then
		# echo "Please run this script from the proper root directory."
		# exit 1
		echo "Running indirectly, will download the latest and initiate the script from there."
		curl -L -o ~/kairos-dev.tar.gz https://github.com/rbreaves/kairos/archive/refs/heads/dev.tar.gz
		tar -xvzf ~/kairos-dev.tar.gz
		cd ~/kairos-dev
		./linux.sh
		exit 1
	fi
elif [ "$1" == "--debug" ];then
	echo "Entered Debug Mode"
	apt_quiet=""
else
	if ! [[ -d "./configs" ]]; then
		# echo "Please run this script from the proper root directory."
		# exit 1
		echo "Running indirectly, will download the latest and initiate the script from there."
		curl -L -o ~/kairos-main.tar.gz https://github.com/rbreaves/kairos/archive/refs/heads/main.tar.gz
		tar -xvzf ~/kairos-main.tar.gz
		cd ~/kairos-main
		./linux.sh
		exit 1
	fi
fi

source ./functions/colors.sh

main() {

	echo "Apt parameters: $apt_quiet"
	echo "Temporarily disabling IPv6 to avoid possible delays and hanging processes."
	echo -e "sudo sysctl net.ipv6.conf.all.disable_ipv6=1\n"

	echo -e "${BWHITE}Kairos - ${NC}${BRED}Fast${NC} ${BYELLOW}Dev${NC} ${BGREEN}Environment${NC} ${BWHITE}Setup Script${NC}\n"

	which yq >/dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo "Installing yq for yaml parsing..."
		wget -qO yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
		chmod +x ./yq
		sudo cp ./yq /usr/bin/yq
	fi
	# which snap >/dev/null 2>&1
	# if [ $? -eq 1 ]; then
	# 	question="To continue we will need to install the Snap Package Manager. Is this ok?"
	# 	choices=(*yes no)
	# 	response=$(prompt "$question" $choices)
	# 	if [ "$response" == "y" ];then
	# 		success="Snapd installed successfully, now continuing..."
	# 		failure="Snapd failed to install. Cancelling install."
	# 		echo "Apt-get updating, please wait..."
	# 		sudo apt-get $apt_quiet update
	# 		# running "If snapd hangs with 'Waiting for server to restart' you can run the following in another tab."
	# 		# echo -e "sudo systemctl restart snapd snapd.socket\n"
	# 		echo "Installing snapd, please wait..."
	# 		sudo apt-get $apt_quiet -y install snapd
	# 		canary $? "$success" "$failure"
	# 		if [ $? -eq 0 ]; then
	# 			echo "Grab a snickers - this might take awhile, installing snapd update & then yq."
	# 			sudo snap install snapd
	# 			sudo snap install yq
	# 			if [ $? -ne 0 ]; then
	# 				ranfailure "yq for parsing yaml configs failed to install. Please re-run this installer and try again."
	# 				exit 0
	# 			fi
	# 		else
	# 			exit 0
	# 		fi
	# 	else
	# 		echo "User cancelled installed."
	# 		exit 0
	# 	fi
		
		# question='Add ppa:rmescandon/yq for parsing yaml configs?'
		# choices=(*yes no cancel all)
		# response=$(prompt "$question" $choices)
		
		# if [ "$response" == "y" ];then
		# 	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
		# 	sudo add-apt-repository ppa:rmescandon/yq
		# 	sudo apt-get update
		# 	sudo apt-get install yq -y
		# else
		# 	exit 0
		# fi
	# else
	# 	# yq --version
	# 	# yq version 4.6.1
	# 	which yq >/dev/null 2>&1
	# 	if [ $? -eq 1 ]; then
	# 		snap install yq
	# 	fi
	# fi

	# Cleans up yaml file
	# eval $(yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | (path | join("_")) + "=" + .' ./configs/ubuntu.yaml \
	# 	| awk '!/=$/{print }' | sed "s/\"/\\\\\"/g" | awk -F'=' '{print $1"=""\""$2"\""}' | sed "s/_\([0-9]\+\)=/\[\1\]=/gm")
	# | remove blanks | escapes existing quotes | properly quotes values

	configs="./configs/*"
	no_match=1
	for f in $configs; do
		# echo "Processing $f file..."
		yq eval "select(.Distro == \"`echo $distro`\")" $f | grep -q "DE: $dename$"
		if [ $? -eq 0 ]; then
			no_match=0
			eval $(yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | (path | join("_")) + "=" + .' $f \
			| awk '!/=$/{print }' | sed "s/\"/\\\\\"/g" | awk -F'=' '{print $1"=""\""$2"\""}' | sed "s/_\([0-9]\+\)=/\[\1\]=/gm")
		fi
	done

	# yq eval 'select(.Distro == "Ubuntu")' ./configs/ubuntu.yaml | grep "DE: Gnome"

	# echo "$Install_Postscript"
	# eval "$Install_After"

	echo "${BWHITE}Setup templates are based on these parameters.${NC}"
	echo ""
	echo "${BWHITE}Distro Release:${NC} ${BGREEN}$distro${NC}"
	echo "${BWHITE}Desktop Environment:${NC} ${BGREEN}$dename${NC}"
	echo "${BWHITE}DE Version:${NC} ${BGREEN}$deversion${NC}"
	echo "${BWHITE}Distro Version:${NC} ${BGREEN}$distroversion${NC}"

	if [ $no_match -eq 1 ]; then
		echo "No config file for your OS was found."
		exit 0
	fi

	if [ -n "${Install_Prescript}" ]; then
		echo ""
		sudo DEBIAN_FRONTEND=noninteractive apt-get update < /dev/null > /dev/null
		# if [ echo $? ]; then
		# 	updateRan=true;
		# fi
		echo "${ULINEYELLOW}Phase 1/3 Pre-Install [ Pre-setup scripts: ${Install_Prescript[@]} ]${NC}"
		for i in "${Install_Prescript[@]}";do
			if [ -f "./prescript/$i.sh" ]; then
				echo ""
				echo "${BYELLOW}Running prescript $i...${NC}"
				bash "./prescript/$i.sh"
				if [[ $(echo $?) -eq 1 ]]; then
					echo "${BRED}**Finished $i with errors.**${NC}"
				else
					echo "${BGREEN}*Finished $i.*${NC}"
				fi
			fi
		done
	fi

	echo ""
	if [ -n "${Install_Packages}" ]; then
		echo "${ULINEYELLOW}Phase 2/3 Install Packages${NC}"
		echo -e "${BWHITE}The following packages are about to be installed, do you want to proceed?${NC}\n${Install_Packages[@]}"
		question=""
		choices=(*yes no)
		response=$(prompt "$question" $choices)
		if [ "$response" == "y" ];then
			for i in "${Install_Packages[@]}";do
				if [ -f "./repos/$i.sh" ]; then
					echo ""
					echo "${BYELLOW}Adding repo for $i...${NC}"
					"./repos/$i.sh"
					# echo "${BGREEN}Finished $i.${NC}"
				fi
			done
			echo ""
			echo "${BYELLOW}Installing all packages...${NC}"
			# Do not remove - repo updates may need this update to be ran again
			sudo DEBIAN_FRONTEND=noninteractive apt-get update < /dev/null > /dev/null
			count=1
			for i in "${Install_Packages[@]}";do
				sudo DEBIAN_FRONTEND=noninteractive apt-get $apt_quiet -y install $i < /dev/null > /dev/null
				if [[ $(echo $?) -eq 1 ]]; then
					ranfailure "**Failed to install $i.**"
				# else
				# 	echo "${BGREEN}*Finished $i.*${NC}"
				else
					ransuccess "[$count/${#Install_Packages[@]}] $i install succeeded."
				fi
				count=$((count+1))
			done
			# sudo apt-get -y install "${Install_Packages[@]}"
			echo "${BGREEN}Finished installing packages.${NC}"
		else
			echo -e "${ULINEYELLOW}Phase 2/3 Install Packages [ Skipping. User did not want to install pkgs. ]${NC}"
		fi
	else
		echo -e "${ULINEYELLOW}Phase 2/3 Install Packages [ Skipping. Nothing configured. ]${NC}"
	fi

	echo ""
	if [ -n "${Install_Postscript}" ]; then
		echo -e "${ULINEYELLOW}Phase 3/3 [ Install scripts queued to run: ${Install_Postscript[@]} ]${NC}"
		for i in "${Install_Postscript[@]}";do
			if [ -f "./scripts/$i.sh" ]; then
				echo ""
				echo "${BYELLOW}Installing $i...${NC}"
				"./scripts/$i.sh"
				echo "${BGREEN}Finished $i.${NC}"
			fi
		done
	else
		echo -e "${ULINEYELLOW}Phase 3/3 Remove packages [ Skipping. Nothing configured. ]${NC}\n"
	fi

	echo -e "\nIf your terminal looks weird, aka broken fonts, theme, etc, you may need to close it and re-open it or even log off and back on for the zsh default shell to take effect."

}

source ./functions/prompt.sh

main "$@"; exit