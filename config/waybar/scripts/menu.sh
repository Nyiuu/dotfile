#!/usr/bin/env bash
set -euo pipefail

wallpaper_dir="${WALLPAPER_DIR:-$HOME/Pictures/Wallpaper}"
current_wallpaper="$HOME/.config/rofi/.current_wallpaper"
rofi_theme="$HOME/.config/rofi/config.rasi"

notify() {
  notify-send -u low "$1" "${2:-}" 2>/dev/null || true
}

reload_ui() {
  swaync-client --reload-config >/dev/null 2>&1 || true
  swaync-client --reload-css >/dev/null 2>&1 || true
  if command -v waybar-msg >/dev/null 2>&1; then
    waybar-msg cmd reload >/dev/null 2>&1 || true
  else
    pkill -SIGUSR2 waybar >/dev/null 2>&1 || true
  fi
}

ensure_swww_daemon() {
  if swww query >/dev/null 2>&1; then
    return 0
  fi

  setsid -f swww-daemon >/tmp/swww-daemon.log 2>&1

  for _ in {1..30}; do
    if swww query >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.1
  done

  notify "Wallpaper error" "swww-daemon did not start"
  return 1
}

apply_wallpaper() {
  local image="$1"

  mkdir -p "$(dirname "$current_wallpaper")"
  ln -sf "$image" "$current_wallpaper"

  ensure_swww_daemon
  swww img "$image" --transition-type any --transition-duration 0.8
  wallust run -s "$image" >/dev/null 2>&1 || true
  reload_ui
  notify "Wallpaper applied" "$(basename "$image")"
}

choose_wallpaper() {
  if [[ ! -d "$wallpaper_dir" ]]; then
    notify "Wallpaper directory missing" "$wallpaper_dir"
    exit 1
  fi

  local selection
  selection="$(
    find "$wallpaper_dir" -maxdepth 2 -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) \
      | sort \
      | sed "s#^$wallpaper_dir/##" \
      | rofi -dmenu -i -p "Wallpaper" -config "$rofi_theme"
  )"

  [[ -n "$selection" ]] || exit 0
  apply_wallpaper "$wallpaper_dir/$selection"
}

quick_menu() {
  local choice
  choice="$(printf '%s\n' \
    "Applications" \
    "Wallpaper" \
    "Reload Theme" \
    "Notifications" \
    "Power" \
    | rofi -dmenu -i -p "Desktop" -config "$rofi_theme")"

  case "$choice" in
    Applications) rofi -show drun -modi drun,run,window -config "$rofi_theme" ;;
    Wallpaper) choose_wallpaper ;;
    "Reload Theme")
      if [[ -e "$current_wallpaper" ]]; then
        wallust run -s "$(readlink -f "$current_wallpaper")" >/dev/null 2>&1 || true
        reload_ui
      fi
      ;;
    Notifications) swaync-client -t -sw ;;
    Power) wlogout --layout "$HOME/.config/wlogout/layout" --css "$HOME/.config/wlogout/style.css" ;;
  esac
}

case "${1:-menu}" in
  menu) quick_menu ;;
  launcher) rofi -show drun -modi drun,run,window -config "$rofi_theme" ;;
  wallpaper) choose_wallpaper ;;
  theme) [[ -e "$current_wallpaper" ]] && wallust run -s "$(readlink -f "$current_wallpaper")"; reload_ui ;;
  notifications) swaync-client -t -sw ;;
  power) wlogout --layout "$HOME/.config/wlogout/layout" --css "$HOME/.config/wlogout/style.css" ;;
  set) [[ $# -eq 2 ]] || { echo "usage: $0 set IMAGE" >&2; exit 2; }; apply_wallpaper "$2" ;;
  *) echo "usage: $0 [menu|launcher|wallpaper|theme|notifications|power]" >&2; exit 2 ;;
esac
