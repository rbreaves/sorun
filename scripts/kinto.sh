#!/usr/bin/env bash

if ! [ -f /usr/lib/systemd/system/xkeysnail.service ];then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/master/install/linux.sh)"
else
	echo "Kinto appears to already be installed. Skipping."
fi