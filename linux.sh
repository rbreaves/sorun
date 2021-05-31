#!/usr/bin/env bash

# Checks to see if running from the web or locally
# will download for a local install if ran remotely
if [ "$1" == "--dev" ];then
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

	echo -e "${BWHITE}Kairos - ${NC}${BRED}Fast${NC} ${BYELLOW}Dev${NC} ${BGREEN}Environment${NC} ${BWHITE}Setup Script${NC}\n"

	which snap >/dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo "Please install snap before continuing."
		exit 0
		
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
	else
		# yq --version
		# yq version 4.6.1
		which yq >/dev/null 2>&1
		if [ $? -eq 1 ]; then
			snap install yq
		fi
	fi

	# Cleans up yaml file
	eval $(yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | (path | join("_")) + "=" + .' ./configs/ubuntu.yaml \
		| awk '!/=$/{print }' | sed "s/\"/\\\\\"/g" | awk -F'=' '{print $1"=""\""$2"\""}' | sed "s/_\([0-9]\+\)=/\[\1\]=/gm")
	# | remove blanks | escapes existing quotes | properly quotes values

	# yq eval 'select(.Distro == "Ubuntu")' ./configs/ubuntu.yaml | grep "DE: Gnome"

	# echo "$Install_Postscript"
	# eval "$Install_After"

	distro=$(awk -F= '$1=="NAME" { print $2 ;}' /etc/os-release | tr -d \'\")
	destring=$("./functions/dename.sh")
	IFS=', ' read -r -a dearray <<< "$destring"
	dename=${dearray[0]}
	deversion=${dearray[1]}

	echo "${BWHITE}Setup templates are based on these parameters.${NC}"
	echo ""
	echo "${BWHITE}Distro Release:${NC} ${BGREEN}$distro${NC}"
	echo "${BWHITE}Desktop Environment:${NC} ${BGREEN}$dename${NC}"
	echo "${BWHITE}DE Version:${NC} ${BGREEN}$deversion${NC}"

	if [ -n "${Install_Prescript}" ]; then
		echo ""
		# sudo apt-get update
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
		echo "${ULINEYELLOW}Phase 2/3 Install Packages [ queued to run: ${Install_Packages[@]} ]${NC}"
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
		# if [ -z updateRan ]; then
		# 	sudo apt-get update
		# fi
		for i in "${Install_Packages[@]}";do
			sudo apt-get -y install $i
			if [[ $(echo $?) -eq 1 ]]; then
				echo "${BRED}**Failed to install $i.**${NC}"
			# else
			# 	echo "${BGREEN}*Finished $i.*${NC}"
			fi
		done
		# sudo apt-get -y install "${Install_Packages[@]}"
		echo "${BGREEN}Finished installing packages.${NC}"
	fi

	echo ""
	if [ -n "${Install_Postscript}" ]; then
		echo "${ULINEYELLOW}Phase 3/3 [ Install scripts queued to run: ${Install_Postscript[@]} ]${NC}"
		for i in "${Install_Postscript[@]}";do
			if [ -f "./scripts/$i.sh" ]; then
				echo ""
				echo "${BYELLOW}Installing $i...${NC}"
				"./scripts/$i.sh"
				echo "${BGREEN}Finished $i.${NC}"
			fi
		done
	else
		echo "${ULINEYELLOW}Phase 3/3 Remove packages [ Skipping. Nothing configured. ]${NC}"
	fi

}

source ./functions/prompt.sh

main "$@"; exit