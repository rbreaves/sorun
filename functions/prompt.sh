#!/usr/bin/env bash

# $1 - Question
# $2 - array of choices
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
read -rep "${BWHITE}$1${NC} $showKeys" response
	case "@${answerKeys[*]}@" in
			(*"$response"*) response="$(tr [A-Z] [a-z] <<< $response)";break;;
	esac
done

if [ "$response" == "" ]; then
	response="$defaultKey"
fi

echo "$response"