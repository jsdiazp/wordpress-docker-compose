#!/bin/bash

# Function to update and install packages on Alpine
install_alpine_packages() {
  apk update
  apk upgrade
  local packages=(
    bat
    curl
    fzf
    git
    neovim
    zsh
    zsh-vcs
  )
  for pkg in "${packages[@]}"; do
    apk add --quiet "$pkg"
  done
}

# Function to update and install packages on Debian
install_debian_packages() {
  apt update
  apt -y full-upgrade
  apt -y dist-upgrade
  apt -y autoremove
  apt -y autoclean
  local packages=(
    bat
    curl
    fzf
    git
    locales
    neovim
    zsh
  )
  for pkg in "${packages[@]}"; do
    apt install -y "$pkg"
  done
}

# Install oh-my-zsh and plugins
install_zsh_extras() {
  # Install oh-my-zsh
  rm -rf ~/.oh-my-zsh
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

  # ZSH Autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  echo 'ZSH_AUTOSUGGEST_STRATEGY=(history completion)' >>~/.zshrc

  # ZSH Syntax Highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  echo 'ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)' >>~/.zshrc

  # Locale settings
  sed -i 's/# export LANG=en_US.UTF-8/export LANG=en_US.UTF-8/' ~/.zshrc
  echo 'export LC_ALL=en_US.UTF-8' >>~/.zshrc

  # ZSH Plugins
  local zsh_plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
  )
  sed -i "s/plugins=(git)/plugins=(${zsh_plugins[*]})/" ~/.zshrc

  # fzf configuration
  case $os in
  "alpine")
    echo 'source <(fzf --zsh)' >>~/.zshrc
    ;;
  "debian")
    echo '[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh' >>~/.zshrc
    ;;
  esac

  # Install Starship
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo "eval \"\$(starship init zsh)\"" >>~/.zshrc
}

# Main script
os=""

while (($#)); do
  case $1 in
  --alpine)
    os="alpine"
    ;;
  --debian)
    os="debian"
    ;;
  esac
  shift
done

case $os in
"alpine")
  install_alpine_packages
  ;;
"debian")
  install_debian_packages
  ;;
esac

install_zsh_extras
