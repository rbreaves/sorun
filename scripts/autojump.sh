#!/usr/bin/env bash

if ! [ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ];then
	brew install autojump >/dev/null 2>&1
else
	echo "Autojump is already installed. Skipping."
fi

if ! grep -q 'profile.d/autojump' ~/.bashrc;then
	echo "[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh" >> ~/.bashrc
fi

if ! grep -q 'profile.d/autojump' ~/.zshrc;then
	echo "[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh" >> ~/.zshrc
fi