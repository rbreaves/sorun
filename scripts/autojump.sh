#!/usr/bin/env bash

# Brew based installed

# if ! [ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ];then
# 	brew install autojump >/dev/null 2>&1
# else
# 	echo "Autojump is already installed. Skipping."
# fi

# if ! grep -q 'profile.d/autojump' ~/.bashrc;then
# 	echo "[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh" >> ~/.bashrc
# fi

# if ! grep -q 'profile.d/autojump' ~/.zshrc;then
# 	echo "[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh" >> ~/.zshrc
# fi

# End Brew based insall

if [ -f /usr/share/autojump/autojump.sh ];then
	if ! grep -q 'autojump.sh' ~/.bashrc;then
		echo "[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh"  >> ~/.bashrc
	fi

	if ! grep -q 'autojump.sh' ~/.zshrc;then
		echo "[ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh"  >> ~/.zshrc
	fi
fi