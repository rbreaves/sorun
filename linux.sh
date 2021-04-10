#!/usr/bin/env bash

echo -e "Kairos - Fast Dev Environment Setup Script\n"

# Checks to see if running from the web or locally
# will download for a local install if ran remotely
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

source ./functions/colors.sh

main() {

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

	if [ -n "${Install_Packages}" ]; then
		echo "Packages queued to run: ${Install_Packages[@]}"
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
		sudo apt-get update
		sudo apt-get -y install "${Install_Packages[@]}"
		echo "${BGREEN}Finished installing packages.${NC}"
	fi

	if [ -n "${Install_Postscript}" ]; then
		echo ""
		echo "Install scripts queued to run: ${Install_Postscript[@]}"
		for i in "${Install_Postscript[@]}";do
			if [ -f "./scripts/$i.sh" ]; then
				echo ""
				echo "${BYELLOW}Installing $i...${NC}"
				"./scripts/$i.sh"
				echo "${BGREEN}Finished $i.${NC}"
			fi
		done
	fi

}

function prompt(){
	source ./functions/prompt.sh
}

main "$@"; exit