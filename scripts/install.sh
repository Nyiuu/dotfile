#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_dir="$repo_dir/backups/$(date +%Y%m%d-%H%M%S)"
xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    printf 'ok: %s\n' "$target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/"
    printf 'backup: %s -> %s/\n' "$target" "$backup_dir"
  fi

  ln -s "$source" "$target"
  printf 'link: %s -> %s\n' "$target" "$source"
}

if [[ -d "$repo_dir/home" ]]; then
  while IFS= read -r -d '' file; do
    rel="${file#"$repo_dir/home/"}"
    link_file "$file" "$HOME/$rel"
  done < <(find "$repo_dir/home" -type f -print0)
fi

if [[ -d "$repo_dir/config" ]]; then
  while IFS= read -r -d '' file; do
    rel="${file#"$repo_dir/config/"}"
    link_file "$file" "$xdg_config_home/$rel"
  done < <(find "$repo_dir/config" -type f ! -name '.gitkeep' -print0)
fi

printf '\nDone.\n'
if [[ -d "${backup_dir:-}" ]]; then
  printf 'Existing files were moved to: %s\n' "$backup_dir"
fi
