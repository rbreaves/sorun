# Sorun.me
Desktop Linux for Creators

A consistent desktop experience for developers and creators, regardless of the distro or DE.

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

## Roadmap

So what's next? Well this will be an ongoing project where new apps and configurations will undoubtedly be added over time, so I am just going to list some near to midterm support items, mostly distros I would like to support in the future.

- XUbuntu
- Manajaro Budgie/XFCE/Gnome
- MX Linux
- Ubuntu
- Windows 10

You might have noticed KDE is missing from the list and it is, mostly because I feel like getting a consistent theming experience working under KDE tends to be more difficult than other distros for whatever reason(s). Also its vast options for configurability often leaves it with more complicated and cumbersome menu options. KDE has improved a lot of that however in more recent releases, but I have no idea if I will ever take another deep dive into KDE or not. Others can certainly contribute configs for KDE based distros and I will happily test them and accept them.

If someone wants to contribute to this project then KDE support would be something you could safely pursue. Beyond that anything that helps developers and/or creators with their work and workflows will always have a high priority.
