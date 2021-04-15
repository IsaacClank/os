#!/bin/bash

function main() {
  exit_if_not_run_as_root
  setup_vm
}

function exit_if_not_run_as_root() {
  if [ "$EUID" != "0" ]; then
    echo "Please run as root"
    exit 1
  fi
}

function setup_vm() {
  prompt "Setting Up Virtual Capabilities"
  sudo pacman -Sq --noconfirm libvirt qemu ebtables dnsmasq virt-manager 1>/dev/null	
}

function prompt() {
  tput setaf 2
  printf "\n\t--- %s ---\n\n" "$1"
  tput sgr0
}

main "$@"
