#!/bin/bash

PACKAGES=(
  acpi-light
  arc-gtk-theme
  autotiling
  batsignal
  blueman
  calibre
  dropbox
  dunst
  feh
  file-roller
  firefox-developer-edition
  flameshot
  geary
  gnome-keyring
  gvfs
  htop
  ibus-unikey
  i3-gaps
  i3lock
  imagemagick
  jq
  kitty
  libsecret
  lxappearance-gtk3
  neovim-nightly-bin
  nerd-fonts-fira-code
  nerd-fonts-fira-mono
  network-manager-applet
  papirus-icon-theme
  pavucontrol
  picom
  polkit-gnome
  polybar
  python-wheel
  qbittorrent
  redshift
  reflector
  rofi
  seahorse
  thunar
  thunar-archive-plugin
  thunar-volman
  tumbler
  ttf-fira-sans
  udisks2
  vlc
  xbindkeys
  xclip
  xcursor-breeze
  xdg-utils
  xdman
)

function main() {
  install_packages
  post_config
}

function install_packages() {
  prompt "Installing Essential Packages"
  yay -Sq --needed --noconfirm "${PACKAGES[@]}"
}

function post_config() {
  # Disable mouse acceleration
  printf "Section \"InputClass\"\
    \n\tIdentifier \"MyMouse\"\
    \n\tMatchIsPointer \"yes\"\
    \n\tOption \"AccelerationNumerator\" \"1\"\
    \n\tOption \"AccelerationDenominator\" \"1\"\
    \n\tOption \"AccelerationThreshold\" \"0\"\
    \nEndSection\n" | sudo tee -a /etc/X11/xorg.conf.d/50-mouse-accelerration.conf

  # Brightness
  printf "%s\n" "ACTION==\"add\", SUBSYSTEM==\"backlight\", RUN+=\"/bin/chgrp video /sys/class/backlight/%k/brightness\"" | sudo tee -a /etc/udev/rules.d/90-backlight.rules
  printf "%s\n" "ACTION==\"add\", SUBSYSTEM==\"backlight\", RUN+=\"/bin/chmod g+w /sys/class/backlight/%k/brightness\"" | sudo tee -a /etc/udev/rules.d/90-backlight.rules

  # Ibus
  printf "GTK_IM_MODULE=ibus\
    \nQT_IM_MODULE=ibus\
    \nXMODIFIERS=@im=ibus\n" | sudo tee -a /etc/environment

  # Touchpad
  printf "Section \"InputClass\"
  Identifier \"touchpad\"
  Driver \"libinput\"
  MatchIsTouchpad \"on\"
  Option \"Tapping\" \"on\"
  Option \"ClickMethod\" \"clickfinger\"
  Option \"NaturalScrolling\" \"on\"
  EndSection\n" | sudo tee -a /etc/X11/xorg.conf.d/30-touchpad.conf
}

function prompt() {
  tput setaf 2
  printf "\n\t--- %s ---\n\n" "$1"
  tput sgr0
}
