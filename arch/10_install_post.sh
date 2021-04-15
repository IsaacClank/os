#!/bin/bash

function main() {
  update_system
  install_yay
  setup_audio
  setup_bluetooth
}

function update_system() {
  prompt "Performing System Update"
  sudo pacman -Syyu --noconfirm
}

function install_yay() {
  prompt "Installing yay"
  git clone https://aur.archlinux.org/yay.git
  cd yay && makepkg -si --noconfirm && cd - && rm -rf yay
}

function setup_audio() {
  prompt "Unmuting Audio Channels."
  amixer sset Master unmute
  amixer sset Speaker unmute
  amixer sset Headphone unmute
}

function setup_bluetooth() {
  prompt "Setting Up Bluetooth"

  prompt "Installing packages"
  echo "AutoEnable=true" | sudo tee -a /etc/bluetooth/main.conf

  systemctl enable bluetooth.service
  systemctl start bluetooth.service
}

function prompt() {
  tput setaf
  printf "\n\t--- %s ---\n\n" "$1"
  prompt -h "SETTING UP AUDIO"
  tput sgr0
}
