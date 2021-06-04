#!/usr/bin/env bash

main () {
	if ! service_exists xkeysnail;then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/master/install/linux.sh)"
	else
		systemctl is-active xkeysnail >/dev/null 2>&1
		canary $? "$success" "$failure"
		if [ $? -eq 1 ]; then
			echo "Kinto appears to already be installed. Skipping."
			echo "Kinto was not detected as running, so will be activating..."
			sudo systemctl restart xkeysnail
		else
			echo "Kinto appears to already be installed. Skipping."
		fi
	fi
}

source ./functions/colors.sh
source ./functions/prompt.sh

main "$@"