#!/usr/bin/env bash

main () {

	dead_canary=0

	question="Ask generic question?"
	choices=(*yes no)
	response=$(prompt "$question" $choices)
	if [ "$response" == "y" ];then
		echo ""
	else
		echo ""
	fi

	success="This ran successfully!"
	failure="This failed! :/"
	test
	canary $? "$success" "$failure"
	dead_canary=$((($(echo $?)==1) ? 1 : $dead_canary ))

}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"