#!/usr/bin/env bash

echo -e "Kairos - Fast Dev Environment Setup Script\n"


# Sets defaults and asks all questions before the installer begins

apps="sublime-text xfce4-terminal vim zsh tmux remmina font-manager"

if [ "$1" == "-a" ];then
	kintoyn="y"
	virtualboxyn="y"
	projectsyn="y"
	apps="${apps} virtualbox virtualbox-ext-pack"
	echo -e "All programs and options will be installed.\n"
	echo "Kinto remapper will be installed."
	echo -e "Virtualbox w/ extension pack will be installed.\n"
	echo -e "Git projects Kinto & Kairos will be added to ~/Documents/git-projects.\n"
	echo "These programs will be installed."
	echo -e "$apps\n"
	read -p 'Press Any key to confirm...' anykey
else
	kintoyn="n"
	virtualboxyn="n"
	projectsyn="n"
fi

if [ $# -eq 0 ] || [ "$1" == "-l" ];then
	echo -e "Will install all programs first, but first answer the following questions."
	while true; do
	read -rep $'\nWould you like to install or reinstall Kinto? [Y/n]\n' kintoyn
		case $kintoyn in
			[Yy]* ) echo "Will install Kinto";kintoyn="y"; break;;
			[Nn]* ) echo "Installing Kinto will be skipped";kintoyn="n";break;;
			* ) echo "Will install Kinto";kintoyn="y";break;;
		esac
	done

	while true; do
	read -rep $'\nWould you like to install Virtualbox? [Y/n]\n' virtualboxyn
		case $kintoyn in
			[Yy]* ) echo "Will install Virtualbox";virtualboxyn="y"; break;;
			[Nn]* ) echo "Installing Virtualbox will be skipped";virtualboxyn="n";break;;
			* ) echo "Will install Virtualbox";virtualboxyn="y";break;;
		esac
	done

	while true; do
	read -rep $'\nCreate git-projects folder under Documents with Kinto and Kairos inside? [Y/n]\n' projectsyn
		case $kintoyn in
			[Yy]* ) echo "Will setup git-projects";projectsyn="y"; break;;
			[Nn]* ) echo "git-projects setup will be skipped";projectsyn="n";break;;
			* ) echo "Will setup git-projects";projectsyn="y";break;;
		esac
	done

	echo ""
fi

if [ "$1" == "-k" ] || [ "$2" == "-k" ];then
	echo "Will install Kinto"
	kintoyn="y"
elif [ "$1" == "-l" ] || [ "$2" == "-l" ];then
	echo "Sublime only install"
	apps="sublime-text"
elif [ "$1" == "-lk" ] || [ "$2" == "-kl" ];then
	echo "Will install Kinto"
	kintoyn="y"
	echo "Sublime only install"
	apps="sublime-text"
fi

# Defaults end, questions are done.


# Import distro and dename info

typeset -l distro
distro=$(awk -F= '$1=="NAME" { gsub("[\",!,_, ]","",$2);print $2 ;}' /etc/os-release)
typeset -l dename
dename=$(./dename.sh | cut -d " " -f1)

# Running the script

echo -e "Install Distro specific programs...\n"

if pkgmgr="$( which apt-get )" 2> /dev/null; then
	echo "Debain based setup"
	sudo $pkgmgr update
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
	sudo $pkgmgr -y install apt-transport-https
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update
	sudo apt-get install git $apps
elif pkgmgr="$( which dnf )" 2> /dev/null; then
	echo "Fedora based setup"
	sudo $pkgmgr check-update
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo $pkgmgr config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	sudo $pkgmgr -y install git $apps
elif pkgmgr="$( which pacman )" 2> /dev/null; then
	echo "Arch-based"
	sudo $pkgmgr -Syy
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
	yes | sudo $pkgmgr -Syu $apps
elif pkgmgr="$( which yum )" 2> /dev/null; then
	echo "Redhat-based"
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	sudo $pkgmgr -y install git $apps
elif pkgmgr="$( which zypper )" 2> /dev/null; then
	echo "openSUSE-based"
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo $pkgmgr addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	sudo $pkgmgr refresh
	sudo $pkgmgr -n install git $apps
else
	echo "Package manager not found/supported" >&2
	exit 1
fi

if [ "$apps" != "sublime-text" ];then
	echo "Install files, fonts, etc..."
	mkdir ~/.fonts
	wget https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf -P ~/.fonts
	fc-cache -f -v
fi

if [ "$kintoyn" == "y" ];then
	echo "Installing Kinto..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/master/install/linux.sh)"
fi

if [ "$projectsyn" == "y" ];then
	echo -e "\nSetup git-projects..."
	if [ -d "~/Documents/git-projects" ];then
		mkdir ~/Documents/git-projects
	fi
	cd ~/Documents/git-projects
	if [ -d "~/Documents/git-projects/kinto" ];then
		git clone https://github.com/rbreaves/kinto.git
	else
		echo "Kinto repo already exists."
	fi
	if [ -d "~/Documents/git-projects/kairos" ];then
		git clone https://github.com/rbreaves/kairos.git
	else
		echo -e "Kairos repo already exists.\n"
	fi
fi

if [ "$apps" != "sublime-text" ];then
	echo "Install oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi