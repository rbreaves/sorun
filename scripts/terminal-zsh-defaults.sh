#!/usr/bin/env bash

source ./functions/colors.sh

if ! fc-list | grep -q "DejaVu Sans Mono for Powerline" &> /dev/null;then
	# do not overwrite -nc
	# overwrite -O
	mkdir -p ~/.fonts/
	wget https://github.com/powerline/fonts/blob/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf\?raw\=true -O "$HOME/.fonts/DejaVu Sans Mono for Powerline.ttf"
	# sudo mv "$HOME/.fonts/DejaVu Sans Mono for Powerline.ttf" /usr/share/fonts/
	fc-cache -f -v
fi

mkdir -p ~/.config/xfce4
mkdir -p ~/.config/xfce4/terminal

if ! [ -d "$HOME/.oh-my-zsh" ];then
	echo -e "\n${BRED}*** After installing oh-my-zsh type in 'exit' to continue ***${NC}\n"
	echo "Install oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	echo "Note: **May need to logoff and back on to see zsh as the default shell.**"
fi

cp ./assets/terminalrc ~/.config/xfce4/terminal/terminalrc
sudo sed -i 's/Name=Xfce Terminal/Name=Terminal/g' /usr/share/applications/xfce4-terminal.desktop
sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"agnoster\"/g' ~/.zshrc
echo "Copy and paste the following, depending on your shell."
echo "source ~/.zshrc"
echo "source ~/.bashrc"