#!/bin/bash

# Function to log messages with a timestamp
log() {
  local message=$1
  local add_newline_before=${2:-true}
  local add_newline_after=${3:-true}
  local log_level=${4:-INFO}
  local formatted_message=""

  if [[ -n $message ]]; then
    formatted_message="\033[0;35m[$(date +"%Y-%m-%d %H:%M:%S")] [$log_level] ⚡️ $message\033[0m"
    [[ $add_newline_before == true ]] && formatted_message="\n$formatted_message"
    [[ $add_newline_after == true ]] && formatted_message="$formatted_message\n"
    echo -e "$formatted_message"
  fi
}

# Function to update and install packages on Alpine
install_alpine_packages() {
  log "Updating and upgrading Alpine packages..." true false
  local ops=(
    update
    upgrade
  )
  for operation in "${ops[@]}"; do
    if apk "$operation"; then
      log "$operation completed successfully" false true
    else
      log "Failed to $operation" false true "ERROR"
      exit 1
    fi
  done

  local packages=(
    bat
    curl
    fzf
    git
    neovim
    zoxide
    zsh
    zsh-vcs
  )
  for pkg in "${packages[@]}"; do
    if apk add --quiet "$pkg"; then
      log "Installed $pkg" false true
    else
      log "Failed to install $pkg" false true "ERROR"
      exit 1
    fi
  done
}

# Function to update and install packages on Debian
install_debian_packages() {
  log "Updating and upgrading Debian packages..." true false
  local ops=(
    update
    full-upgrade
    dist-upgrade
    autoremove
    autoclean
  )
  for operation in "${ops[@]}"; do
    if apt "$operation" -y; then
      log "$operation completed successfully" false true
    else
      log "Failed to $operation" false true "ERROR"
      exit 1
    fi
  done

  local packages=(
    bat
    curl
    git
    locales
    neovim
    zoxide
    zsh
  )
  for pkg in "${packages[@]}"; do
    if apt install -y "$pkg"; then
      log "Installed $pkg" false true
    else
      log "Failed to install $pkg" false true "ERROR"
      exit 1
    fi
  done

  locale-gen en_us.UTF-8
}

# Function to install a Zsh plugin from a GitHub repository
install_zsh_plugin() {
  local repo="$1"
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$(basename "$repo")"

  if [[ -d "$dir" ]]; then
    log "Plugin directory $dir already exists. Removing and reinstalling $repo." false
    rm -rf "$dir"
  fi

  if git clone "https://github.com/$repo" "$dir"; then
    log "Installed Zsh plugin $repo" false true
  else
    log "Failed to install Zsh plugin $repo" false true "ERROR"
    exit 1
  fi
}

add_zshrc_code() {
  local comment=$1
  local code=$2
  echo -e "\n# $comment\n$code" >>"$HOME/.zshrc"
}

# Install oh-my-zsh and plugins
install_zsh_extras() {
  # Install oh-my-zsh
  rm -rf ~/.oh-my-zsh
  if git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"; then
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc"
    log "Installed oh-my-zsh" false true
  else
    log "Failed to install oh-my-zsh" false true "ERROR"
    exit 1
  fi

  # ZSH Autosuggestions
  install_zsh_plugin zsh-users/zsh-autosuggestions
  add_zshrc_code "ZSH Autosuggestions" "ZSH_AUTOSUGGEST_STRATEGY=(history completion)"

  # ZSH Syntax Highlighting
  install_zsh_plugin zsh-users/zsh-syntax-highlighting
  add_zshrc_code "ZSH Syntax Highlighting" "ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)"

  # Locale settings
  sed -i 's/# export LANG=en_US.UTF-8/export LANG=en_US.UTF-8/' "$HOME/.zshrc"
  add_zshrc_code "Locale" "export LC_ALL=en_US.UTF-8"

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
    add_zshrc_code "fzf" "source <(fzf --zsh)"
    ;;
  "debian")
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    echo y | ~/.fzf/install
    ;;
  esac

  # Install Starship
  if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
    add_zshrc_code "starship" "eval \"\$(starship init zsh)\""
    log "Installed Starship prompt" false true
  else
    log "Failed to install Starship prompt" false true "ERROR"
    exit 1
  fi

  # Install Zoxide
  add_zshrc_code "Zoxide" "eval \"\$(zoxide init zsh)\""
}

# Main script
main() {
  os=""

  while (($#)); do
    case $1 in
    --alpine)
      os="alpine"
      ;;
    --debian)
      os="debian"
      ;;
    *)
      log "Invalid argument: $1" true true "ERROR"
      exit 1
      ;;
    esac
    shift
  done

  if [[ -z $os ]]; then
    log "No OS specified. Use --alpine or --debian." true true "ERROR"
    exit 1
  fi

  case $os in
  "alpine") install_alpine_packages ;;
  "debian") install_debian_packages ;;
  esac

  install_zsh_extras
}

main "$@"
