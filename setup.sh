#!/bin/bash

## Run archinstall to install with BTRFS Snapshots

## Bulk Package Install
user="oldmanz"
git_email="travis@oldmanz.com"
git_name="oldmanz"


pacman --needed -S i3-gaps i3blocks i3lock i3status

pacman --needed -S stow git docker alacritty ranger atool unzip rofi dbeaver remmina freerdp brightnessctl python3 python-pip sof-firmware nm-connection-editor network-manager-applet flameshot neovim android-tools picom dunst feh unclutter ttf-fira-code ttf-font-awesome acpi emacs-nativecomp ripgrep fd udiskie shellcheck marked

## Yay setup
if [ ! -d "/opt/yay-git" ] ; then
  cd /opt
  git clone https://aur.archlinux.org/yay-git.git
  chown -R oldmanz ./yay-git
  cd yay-git
  sudo -H -u oldmanz bash -c makepkg -si
fi

## Yay Packages
sudo -H -u oldmanz bash -c 'yay --needed -S google-chrome slack-desktop visual-studio-code-bin postman-bin scrcpy ly'


## Ly Setup
systemctl enable ly


# Docker Setup
systemctl enable --now docker
usermod -aG docker $user
newgrp docker

# SSH Setup
if [ ! -d "/home/$user/.ssh" ]; then
	mkdir /home/$user/.ssh
fi
if [ ! -f "/home/$user/.ssh/id_ed25519.pub" ]; then
		echo Creating SSH Key
		ssh-keygen -t ed25519 -N '' -f "/home/$user/.ssh/id_ed25519" -C "$git_email"
		eval "$(ssh-agent -s)"
		ssh-add ~/.ssh/id_ed25519
		cat /home/$user/.ssh/id_ed25519.pub
		chown -R oldmanz /home/$user/.ssh
	fi

# Vim Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Git Setup
git config --global user.email "$git_email"
git config --global user.name "$git_name"
