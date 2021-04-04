#!/usr/bin/env bash

typeset -l distro
distro=$(awk -F= '$1=="NAME" { gsub("[\",!,_, ]","",$2);print $2 ;}' /etc/os-release)
typeset -l dename
dename=$(./dename.sh | cut -d " " -f1)

echo "Install Distro specific programs..."

if pkgmgr="$( which apt-get )" 2> /dev/null; then
	echo "Debain based setup"
	sudo apt-get update

	# Install Sublime Text 3
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo apt-get -y install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install sublime-text
elif pkgmgr="$( which dnf )" 2> /dev/null; then
	echo "Fedora based setup"
	sudo dnf check-update
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	sudo dnf -y install sublime-text
elif pkgmgr="$( which pacman )" 2> /dev/null; then
	echo "Arch-based"
	sudo pacman -Syy
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
	yes | sudo pacman -Syu sublime-text
elif pkgmgr="$( which yum )" 2> /dev/null; then
	echo "Redhat-based"
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	sudo yum -y install sublime-text
else
	echo "Package manager not found/supported" >&2
	exit 1
fi

while true; do
read -rep $'\nWould you like to install or reinstall Kinto? [Y/n]\n' yn
	case $yn in
		[Yy]* ) yn="y"; break;;
		[Nn]* ) yn="n";break;;
		* ) yn="y";break;;
	esac
done

if [ "$yn" == "y" ];then
	echo "Installing Kinto..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/master/install/linux.sh)"	
fi