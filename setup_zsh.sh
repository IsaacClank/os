#/bin/bash

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

function main() {
  install_zsh
  install_zplug
}

function install_zsh() {
  prompt "Installing zsh."

  if apt --version &>/dev/null; then
    printf "\nDetect Debian-based distro\n"
    sudo apt install -y zsh
  elif pacman --version &>/dev/null; then
    printf "\nDetect Arch-based distro\n"
    sudo pacman -Sq --noconfirm zsh
  fi
}

function install_zplug() {
  prompt "Installing ZPlug"

  export ZPLUG_HOME="$HOME/.zplug"
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
}

main "$@"
