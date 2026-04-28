#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  sudo_cmd=()
else
  sudo_cmd=(sudo)
fi

pacman_packages=(
  base-devel
  git
  zsh
  zsh-autosuggestions
  zsh-syntax-highlighting
  neovim
  lua-language-server
  clang
  stylua
  python-isort
  python-black
  rustup
  ripgrep
  fd
  unzip
  gcc
  make
  nvm
  zellij
  yazi
  alacritty
  niri
  waybar
  mako
  wl-clipboard
  cliphist
  polkit-gnome
  fcitx5
  fcitx5-gtk
  fcitx5-qt
  playerctl
  brightnessctl
  pipewire
  wireplumber
  fuzzel
  satty
  awww
)

aur_packages=(
  waypaper
  niriswitcher
  clash-verge-rev
)

install_pacman_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    printf 'error: this dependency script is for Arch Linux / pacman systems.\n' >&2
    exit 1
  fi

  "${sudo_cmd[@]}" pacman -Syu --needed --noconfirm "${pacman_packages[@]}"
}

install_aur_packages() {
  local helper=""

  if command -v yay >/dev/null 2>&1; then
    helper="yay"
  elif command -v paru >/dev/null 2>&1; then
    helper="paru"
  fi

  if [[ -z "$helper" ]]; then
    printf 'skip: AUR helper not found; install manually if needed: %s\n' "${aur_packages[*]}"
    return
  fi

  "$helper" -S --needed --noconfirm "${aur_packages[@]}"
}

install_oh_my_zsh() {
  local zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"
  local custom_dir="${ZSH_CUSTOM:-$zsh_dir/custom}"

  if [[ ! -d "$zsh_dir/.git" ]]; then
    if [[ -e "$zsh_dir" ]]; then
      printf 'skip: %s exists but is not a git checkout\n' "$zsh_dir"
    else
      git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$zsh_dir"
    fi
  fi

  mkdir -p "$custom_dir/plugins" "$custom_dir/themes"

  if [[ ! -d "$custom_dir/plugins/zsh-autosuggestions/.git" ]]; then
    if [[ -e "$custom_dir/plugins/zsh-autosuggestions" ]]; then
      printf 'skip: %s exists but is not a git checkout\n' "$custom_dir/plugins/zsh-autosuggestions"
    else
      git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$custom_dir/plugins/zsh-autosuggestions"
    fi
  fi

  if [[ ! -d "$custom_dir/plugins/zsh-syntax-highlighting/.git" ]]; then
    if [[ -e "$custom_dir/plugins/zsh-syntax-highlighting" ]]; then
      printf 'skip: %s exists but is not a git checkout\n' "$custom_dir/plugins/zsh-syntax-highlighting"
    else
      git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_dir/plugins/zsh-syntax-highlighting"
    fi
  fi

  if [[ ! -d "$custom_dir/themes/powerlevel10k/.git" ]]; then
    if [[ -e "$custom_dir/themes/powerlevel10k" ]]; then
      printf 'skip: %s exists but is not a git checkout\n' "$custom_dir/themes/powerlevel10k"
    else
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$custom_dir/themes/powerlevel10k"
    fi
  fi
}

main() {
  install_pacman_packages

  if [[ "${DOTFILES_SKIP_AUR:-0}" == "1" ]]; then
    printf 'skip: AUR packages skipped by DOTFILES_SKIP_AUR=1: %s\n' "${aur_packages[*]}"
  else
    install_aur_packages
  fi

  if [[ "${DOTFILES_SKIP_EXTERNAL:-0}" == "1" ]]; then
    printf 'skip: external git installs skipped by DOTFILES_SKIP_EXTERNAL=1\n'
  else
    install_oh_my_zsh
  fi

  printf '\nDependencies installed. Run ./scripts/install.sh to link dotfiles.\n'
}

main "$@"
