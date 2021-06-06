# Sorun.me

<img src="https://user-images.githubusercontent.com/10969616/120915683-c3476080-c66a-11eb-99f5-c0e7c45b17b5.png" width="40%" height="40%">

Desktop Linux for Creators

[![GitHub release](https://img.shields.io/github/release/rbreaves/sorun.svg)](https://github.com/rbreaves/sorun/releases/latest)

<img src="https://user-images.githubusercontent.com/10969616/120910938-984c1500-c648-11eb-8aec-07417ee6cf70.png" width="80%" height="80%">

A consistent desktop experience for developers and creators, regardless of the distro or DE.

If you are only interested in the key remapper aspect of Sorun.me then please checkout my other project [kinto.sh](https://github.com/rbreaves/kinto). Sorun.me brings onboard several applications geared towards developers and creators and largely based on my own preferences, but it can be expanded to support more applications, configurations and distros.

## Install (Ubuntu Budgie 20.04 & Pop\!_OS 20.04 Only)

Sorun.me v0.9

Note: The current v0.9 release does not have a proper uninstaller. Please test this on a fresh install or VM only.

```
bash <( curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/rbreaves/sorun/HEAD/linux.sh )
```

Note: When you reach the Oh-my-zsh install part you will need to also type in 'exit' for the installer to continue with the rest of the setup. Also if you want to run the dev branch add --dev to the end, after the ")".

## Git Install Method

```
git clone https://github.com/rbreaves/sorun.git
cd ./sorun
./linux.sh
```

## Install (Windows)

```

```

## How to add packages or scripts?

Given the yaml nature of the config files anyone can quickly add their own preferences or changes to the script.
https://github.com/rbreaves/sorun/tree/main/configs
```
Distro: pop!_os
DE: gnome
Install:
  Prescript:
    # - openssh-config
  Packages:
    - xfce4-terminal
    - xfce4-panel
    - xdotool
    - locate
    - gnome-tweaks
    - gnome-shell-extensions
    ...
Postscript:
    - mojave
    - pop_os-defaults
...
```

If you want to add a post package install script then you can follow the template file or openss-config.sh as interactive examples.
https://github.com/rbreaves/sorun/blob/main/scripts/template.sh
```
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
```

## Roadmap

So what's next? Well this will be an ongoing project where new apps and configurations will undoubtedly be added over time, so I am just going to list some near to midterm support items, mostly distros I would like to support in the future.

- XUbuntu
- Manajaro Budgie/XFCE/Gnome
- MX Linux
- Ubuntu
- Windows 10

You might have noticed KDE is missing from the list and it is, mostly because I feel like getting a consistent theming experience working under KDE tends to be more difficult than other distros for whatever reason(s). Also its vast options for configurability often leaves it with more complicated and cumbersome menu options. KDE has improved a lot of that however in more recent releases, but I have no idea if I will ever take another deep dive into KDE or not. Others can certainly contribute configs for KDE based distros and I will happily test them and accept them.

If someone wants to contribute to this project then KDE support would be something you could safely pursue. Beyond that anything that helps developers and/or creators with their work and workflows will always have a high priority.
