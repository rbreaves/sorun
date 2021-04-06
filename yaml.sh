#!/usr/bin/env bash

main() {
	echo -e "Kairos - Fast Dev Environment Setup Script\n"

	# question='Add ppa:rmescandon/yq for parsing yaml configs?'
	# choices=(*yes no cancel all)

	which snap >/dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo "Please install snap before continuing."
		exit 0

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
		snap install yq
	fi

	# Cleans up yaml file
	eval $(yq eval '.. | select((tag == "!!map" or tag == "!!seq") | not) | (path | join("_")) + "=" + .' ./configs/ubuntu.yaml \
		| awk '!/=$/{print }' | sed "s/\"/\\\\\"/g" | awk -F'=' '{print $1"=""\""$2"\""}')
	# | remove blanks | escapes existing quotes | properly quotes values

	echo "$Install_Packages"
	eval "$Install_After"
}

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
   # Stefan Farestam
   # https://stackoverflow.com/questions/5014632/how-can-i-parse-a-yaml-file-from-a-linux-shell-script
}

function prompt(){
	# $1 - Question
	# $2 - array of choices
	BRED=$'\e[1;31m'
	BYELLOW=$'\e[1;33m'
	GREEN=$'\e[0;32m'
	BGREEN=$'\e[1;32m'
    NC=$'\e[0m'
	choices="$2"
	defaultKey=""
	answerKeys=()
	showKeys=""
	# Set default key and keyboard input keys
	for i in "${choices[@]}"; do
		if [ "${i:0:1}" == "*" ]; then
			newKey+="${i:1}"
			defaultKey="${newKey:0:1}"
			answerKeys+="$(tr [a-z] [A-Z] <<< "${newKey:0:1}")""$(tr [A-Z] [a-z] <<< "${newKey:0:1}")"
			if [ "$(tr [a-z] [A-Z] <<< "${i:1:1}")" == "a" ];then
				showKeys="[${BGREEN}A${NC}]ll/${showKeys}"
			else
				showKeys="${BGREEN}$(tr [a-z] [A-Z] <<< "${i:1:1}")${NC}/${showKeys}"
			fi
		else
			answerKeys+="$(tr [a-z] [A-Z] <<< "${i:0:1}")""$(tr [A-Z] [a-z] <<< "${i:0:1}")"
			if [ "$(tr [a-z] [A-Z] <<< "${i:0:1}")" == "a" ];then
				showKeys+="[a]ll/"
			else
				showKeys+=$(tr [A-Z] [a-z] <<< "${i:0:1}")/
			fi
		fi
	done
	showKeys=["${showKeys::-1}"]

	IFS=@
	while true; do
	read -rep "$1 $showKeys" response
		case "@${answerKeys[*]}@" in
 			(*"$response"*) response="$(tr [A-Z] [a-z] <<< $response)";break;;
		esac
	done

	if [ "$response" == "" ]; then
		response="$defaultKey"
	fi

	echo "$response"
}

main "$@"; exit