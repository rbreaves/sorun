#!/usr/bin/env bash

function main(){
	if ! [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		sudo apt-get -y install build-essential
		brew install gcc

		currentShell=`ps -p $$ | tail -n1 | awk '{print $4}'`
		echo "$currentShell detected as running"

		question='Add homebrew PATH to All shells, Bash, ZSH, or none?'
		choices=(*all bash zsh no)
		response=$(prompt "$question" $choices)

		if command -v bash &> /dev/null && ([ "$response" == "a" ] || [ "$response" == "b" ]);then
			echo "Updating ~/.bashrc"
			if ! grep -q ' PATH=.*linuxbrew' ~/.bashrc;then
				echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"' >> ~/.bashrc
			fi
			if ! grep -q ' MANPATH=.*linuxbrew' ~/.bashrc;then
				echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >> ~/.bashrc
			fi
			if ! grep -q ' INFOPATH=.*linuxbrew' ~/.bashrc;then
				echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >> ~/.bashrc
			fi
		fi
		if command -v zsh &> /dev/null && ([ "$response" == "a" ] || [ "$response" == "z" ]);then
			echo "Updating ~/.zshrc"
			if ! grep -q ' PATH=.*linuxbrew' ~/.zshrc;then
				echo "Updating PATH ~/.zshrc"
				echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"' >> ~/.zshrc
			fi
			if ! grep -q ' MANPATH=.*linuxbrew' ~/.zshrc;then
				echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >> ~/.zshrc
			fi
			if ! grep -q ' INFOPATH=.*linuxbrew' ~/.zshrc;then
				echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >> ~/.zshrc
			fi
		fi
		if ([ "$currentShell" != "zsh" ] && [ "$currentShell" != "bash" ]);then
			echo "$currentShell shell is unknown"
		else
			echo "Please copy and paste the following to reload the shell rc file to use brew."
			if [ "$currentShell" == "zsh" ];then
				echo "source ~/.zshrc"
			else
				echo "source ~/.bashrc"
			fi
		fi
	else
		echo 'Brew is already installed. Skipping.'
	fi
}

source ./functions/colors.sh

function prompt(){
	source ./functions/prompt.sh
}

main "$@"; exit