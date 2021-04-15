#/bin/bash

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

function main() {
  install_zsh
  install_ohmyzsh
  install_plugins
  configure_zshrc
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

function install_ohmyzsh() {
  prompt "Installing Ohmyzsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

function install_plugins() {
  prompt "Installing plugins"
  cd $ZSH_CUSTOM/plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions --depth=1
  git clone https://github.com/zsh-users/zsh-syntax-highlighting --depth=1
  git clone https://github.com/supercrabtree/k --depth=1

  cd ../themes
  git clone https://github.com/denysdovhan/spaceship-prompt.git --depth=1
  ln -s ./spaceship-prompt/spaceship.zsh-theme ./

  cd $ZSH_CUSTOM/themes
  git clone --depth=1 https://github.com/sindresorhus/pure.git
}

function configure_zshrc() {
  printf "export ZSH=\"/home/isaac/.oh-my-zsh\"\
    \nexport DOT=\"/home/isaac/Repos/dotfiles\"\
    \nexport Z_DOT=\"\$DOT/zsh\"\
    \nfpath+=\$Z_DOT/completions\
    \nfpath+=\$Z_DOT/functions\n" >~/.zshrc
  printf "\nZSH_THEME=\"spaceship\"\n" >>~/.zshrc
  printf "\nplugins=(git k zsh-autosuggestions zsh-syntax-highlighting)\n" >>~/.zshrc
  printf "\nsource \$ZSH/oh-my-zsh.sh \
  \nsource \$Z_DOT/alias\n" >>~/.zshrc

  chsh -s /bin/zsh $USER
}

function prompt() {
  tput bold
  tput setaf 2
  printf "\n\t---%s---\n" "$1"
  tput sgr0
}

main "$@"
