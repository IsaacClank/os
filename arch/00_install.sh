#!/bin/bash

REGION="Asia"
CITY="Ho_Chi_Minh"
LOCALE="en_US.UTF-8 UTF-8"
LANG="en_US.UTF-8"
HOSTNAME="arch"
USERNAME="isaac"
PACKAGES=(
  alsa-utils
  base-devel
  bluez
  bluez-utils
  efibootmgr
  git
  grub
  intel-ucode
  mesa
  networkmanager
  os-prober
  pulseaudio
  sudo
  xorg
  xorg-xinit
  zsh
)

function main() {
  view_config
  install_essentials
  configure_system
}

function view_config() {
  prompt "Default Configuration"
  printf "Region:\t\t$REGION\n"
  printf "City:\t\t$CITY\n"
  printf "LOCALE:\t\t$LOCALE\n"
  printf "LANG:\t\t$LANG\n"
  printf "HOST:\t\t$HOSTNAME\n"
  printf "USERNAME:\t$USERNAME\n"
  printf "\nProceed with these configurations? (Y/n)  "

  read confirm
  confirm="${confirm:-Y}"
  if [ "${confirm,,}" != "y" ]; then
    prompt "Inspect script to set your configurations"
    exit 0
  fi
}

function install_essentials() {
  prompt "Installing Essential Packages"
  pacman -Sq --noconfirm "${PACKAGES[@]}"
}

function configure_system() {
  prompt "Configuring System"
  timezone
  locale
  enable_network
  bootloader
  accounts
}

function timezone() {
  prompt "Timezone"
  ln -sf /usr/share/zoneinfo/$REGION/$CITY /etc/localtime
  [[ $? != 0 ]] && exit 1
  hwclock --systohc
  [[ $? != 0 ]] && exit 1

}

function locale() {
  prompt "Locale"
  echo $LOCALE >/etc/locale.gen
  echo "LANG=$LANG" >/etc/locale.conf
  locale-gen
  [[ $? != 0 ]] && exit 1
}

function enable_network() {
  prompt "Network"
  echo $HOSTNAME >/etc/hostname
  printf "127.0.0.1\t\tlocalhost\
    \n::1\t\t\tlocalhost\
    \n127.0.1.1\t\t$HOSTNAME.localdomain $HOSTNAME\n" >/etc/hosts

  systemctl enable NetworkManager.service
}

function bootloader () {
  prompt "Bootloader"
  grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=ARCH
  grub-mkconfig -o /boot/grub/grub.cfg
}

function accounts() {
  prompt "Choose password for root user"
  passwd
  [[ $? != 0 ]] && exit 1

  useradd -m $USERNAME
  passwd $USERNAME
  usermod -aG audio,video,network,wheel,storage,rfkill $USERNAME
  echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/$USERNAME
}

function prompt() {
  tput setaf 2
  printf "\n\t--- %s ---\n\n" "$1"
  tput sgr0
}
