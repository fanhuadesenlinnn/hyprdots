#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DOTS_DIR="${DOTS_DIR:-$SCRIPT_DIR}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config_backup}"
LOCAL_BIN="${LOCAL_BIN:-$HOME/.local/bin}"
DRY_RUN=0
ASSUME_YES=0
INSTALL_PACKAGES=0

PACMAN_PACKAGES=(
  acpi
  atuin
  bat
  bluez
  bluez-utils
  brightnessctl
  btop
  cava
  cliphist
  desktop-file-utils
  dunst
  eza
  fastfetch
  fcitx5
  fcitx5-configtool
  fcitx5-gtk
  fcitx5-qt
  fcitx5-rime
  fd
  fish
  fzf
  git
  grim
  hyprland
  hypridle
  hyprlock
  hyprpaper
  hyprpicker
  hyprpolkitagent
  jq
  kitty
  libnotify
  mesa
  networkmanager
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  obsidian
  pamixer
  pavucontrol
  pipewire
  pipewire-alsa
  pipewire-pulse
  playerctl
  polkit
  rime-luna-pinyin
  rofi
  rtkit
  sddm
  slurp
  starship
  tmux
  ttf-iosevka-nerd
  unzip
  waybar
  wget
  wireplumber
  wl-clipboard
  wtype
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  xdg-utils
  xorg-xwayland
  yazi
  zoxide
)

AUR_PACKAGES=(
  google-chrome
)

CONFIG_MODULES=(
  hypr
  waybar
  rofi
  dunst
  yazi
  fish
  fcitx5
  atuin
  btop
  cava
  kitty
  fastfetch
  starship
  hypridle
  gtk-3.0
  gtk-4.0
)

usage() {
  cat <<EOF
Usage: ./setup.sh [options]

Options:
  -n, --dry-run          Print the planned actions without changing files.
  -y, --yes              Answer yes to prompts.
      --install-packages Install the packages needed for a minimal Arch desktop.
  -h, --help             Show this help.

Environment overrides:
  DOTS_DIR=/path/to/hyprdots
  BACKUP_DIR=/path/to/backups
  LOCAL_BIN=/path/to/bin
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -n | --dry-run)
    DRY_RUN=1
    ;;
  -y | --yes)
    ASSUME_YES=1
    ;;
  --install-packages)
    INSTALL_PACKAGES=1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 1
    ;;
  esac
  shift
done

cecho() {
  local color="$1"
  shift

  case "$color" in
  RED) printf '\033[31m%s\033[0m\n' "$*" ;;
  GREEN) printf '\033[32m%s\033[0m\n' "$*" ;;
  YELLOW) printf '\033[33m%s\033[0m\n' "$*" ;;
  BLUE) printf '\033[34m%s\033[0m\n' "$*" ;;
  MAGENTA) printf '\033[35m%s\033[0m\n' "$*" ;;
  CYAN) printf '\033[36m%s\033[0m\n' "$*" ;;
  *) printf '%s\n' "$*" ;;
  esac
}

die() {
  cecho RED "$*"
  exit 1
}

confirm() {
  local prompt="$1"

  if [[ "$ASSUME_YES" -eq 1 ]]; then
    return 0
  fi

  local answer
  read -r -p "$prompt [y/N]: " answer
  [[ "$answer" == "y" || "$answer" == "Y" || "$answer" == "yes" || "$answer" == "YES" ]]
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

preflight() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    die "Do not run this script as root or with sudo. Run it as your normal user; sudo will be requested when needed."
  fi

  if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
    if [[ ! -f /etc/arch-release ]]; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        cecho YELLOW "Dry-run on a non-Arch host; package commands are only previewed."
      else
        die "This package install path is intended for Arch Linux."
      fi
    fi

    if ! command -v pacman >/dev/null 2>&1; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        cecho YELLOW "pacman not found in dry-run environment."
      else
        die "pacman not found; cannot install Arch packages."
      fi
    fi

    if ! command -v sudo >/dev/null 2>&1; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        cecho YELLOW "sudo not found in dry-run environment."
      else
        die "sudo not found; install sudo and add this user to sudoers first."
      fi
    fi

    if [[ "$DRY_RUN" -eq 0 ]]; then
      sudo -v
    else
      echo "[dry-run] sudo -v"
    fi
  fi
}

timestamp() {
  date +"%Y%m%d-%H%M%S"
}

backup_path_for() {
  local module="$1"
  printf '%s/%s_%s' "$BACKUP_DIR" "$module" "$(timestamp)"
}

copy_config_module() {
  local module="$1"
  local source="$DOTS_DIR/$module"
  local target="$HOME/.config/$module"

  if [[ ! -d "$source" ]]; then
    cecho YELLOW "Skipping $module: source not found at $source"
    return 0
  fi

  if ! confirm "Install $module config to $target?"; then
    cecho YELLOW "Skipped $module."
    return 0
  fi

  cecho CYAN "Installing $module"
  run mkdir -p "$BACKUP_DIR" "$HOME/.config"

  if [[ -e "$target" || -L "$target" ]]; then
    local backup
    backup="$(backup_path_for "$module")"
    cecho YELLOW "Backing up $target to $backup"
    run mv "$target" "$backup"
  fi

  run cp -a "$source" "$target"
  post_install_module "$module" "$target"
  cecho GREEN "$module config installed."
}

make_shell_scripts_executable() {
  local target="$1"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] chmod +x shell scripts under $target"
    return 0
  fi

  find "$target" -type f \( -name "*.sh" -o -perm -u=x \) -exec chmod +x {} +
}

ensure_waybar_env() {
  local env_file="$1/scripts/.env"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -f "$env_file" ]]; then
      echo "[dry-run] preserve existing $env_file"
    else
      echo "[dry-run] create $env_file with GITHUB_USERNAME and GITHUB_PAT placeholders"
    fi
    return 0
  fi

  if [[ ! -f "$env_file" ]]; then
    cat >"$env_file" <<EOF
GITHUB_USERNAME=
GITHUB_PAT=
EOF
  fi
}

copy_local_bin_scripts() {
  local source="$DOTS_DIR/bin"

  if [[ ! -d "$source" ]]; then
    cecho YELLOW "No local bin scripts found at $source"
    return 0
  fi

  run mkdir -p "$LOCAL_BIN"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] copy scripts from $source to $LOCAL_BIN"
    return 0
  fi

  cp -a "$source"/. "$LOCAL_BIN"/
  find "$LOCAL_BIN" -maxdepth 1 -type f -exec chmod +x {} +
}

post_install_module() {
  local module="$1"
  local target="$2"

  case "$module" in
  waybar)
    make_shell_scripts_executable "$target"
    ensure_waybar_env "$target"
    cecho CYAN "Waybar GitHub module uses $target/scripts/.env when enabled."
    ;;
  rofi)
    make_shell_scripts_executable "$target"
    ;;
  dunst)
    copy_local_bin_scripts
    ;;
  yazi)
    if command -v ya >/dev/null 2>&1 && confirm "Install Yazi plugins with 'ya pkg install'?"; then
      run ya pkg install
    fi
    ;;
  fish)
    if command -v fish >/dev/null 2>&1 && confirm "Set Fish as your default shell?"; then
      run chsh -s "$(command -v fish)"
    fi
    ;;
  esac
}

ensure_hyprpaper_config() {
  local config_path="$HOME/.config/hypr/hyprpaper.conf"

  if [[ -f "$config_path" ]]; then
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] create initial $config_path"
    return 0
  fi

  cat >"$config_path" <<EOF
splash = false
EOF
}

install_web_apps() {
  local source="$DOTS_DIR/web-apps"
  local apps_dir="$HOME/.local/share/applications"
  local icons_dir="$apps_dir/icons"
  local desktop_file
  local target_file

  if [[ ! -d "$source" ]]; then
    cecho YELLOW "No web app launchers found at $source"
    return 0
  fi

  if ! confirm "Install Chrome web app launchers to $apps_dir?"; then
    cecho YELLOW "Skipped web app launchers."
    return 0
  fi

  run mkdir -p "$apps_dir" "$icons_dir"

  if [[ -d "$source/icons" ]]; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] copy web app icons from $source/icons to $icons_dir"
    else
      cp -a "$source/icons"/. "$icons_dir"/
    fi
  fi

  while IFS= read -r desktop_file; do
    if [[ "$(basename "$desktop_file")" == "steam.desktop" ]] && ! command -v steam >/dev/null 2>&1; then
      cecho YELLOW "Skipping steam.desktop because steam is not installed."
      continue
    fi

    target_file="$apps_dir/$(basename "$desktop_file")"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] install $desktop_file to $target_file with HOME expanded"
    else
      sed "s|\$HOME|$HOME|g" "$desktop_file" >"$target_file"
      chmod 0644 "$target_file"
    fi
  done < <(find "$source" -maxdepth 1 -type f -name "*.desktop" | sort)

  cecho GREEN "Web app launchers installed."
}

enable_system_services() {
  local services=(
    NetworkManager.service
    bluetooth.service
    sddm.service
  )
  local service

  if [[ "$INSTALL_PACKAGES" -ne 1 ]]; then
    return 0
  fi

  if ! confirm "Enable NetworkManager, Bluetooth, and SDDM for next boot?"; then
    cecho YELLOW "Skipped system service enablement."
    return 0
  fi

  for service in "${services[@]}"; do
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] sudo systemctl enable $service"
    else
      sudo systemctl enable "$service"
    fi
  done

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] sudo systemctl set-default graphical.target"
  else
    sudo systemctl set-default graphical.target
  fi
}

enable_user_audio_services() {
  local services=(
    pipewire.service
    pipewire-pulse.service
    wireplumber.service
  )
  local service

  if [[ "$INSTALL_PACKAGES" -ne 1 ]]; then
    return 0
  fi

  if ! confirm "Enable PipeWire user audio services globally?"; then
    cecho YELLOW "Skipped PipeWire user services."
    return 0
  fi

  for service in "${services[@]}"; do
    if [[ "$DRY_RUN" -eq 1 ]]; then
      echo "[dry-run] sudo systemctl --global enable $service"
    else
      sudo systemctl --global enable "$service"
    fi
  done
}

install_pacman_packages() {
  if ! command -v pacman >/dev/null 2>&1; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      cecho YELLOW "pacman not found; previewing pacman install command anyway."
    else
      die "pacman not found; cannot install pacman packages."
    fi
  fi

  if confirm "Install core pacman packages?"; then
    run sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
  fi
}

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    cecho GREEN "yay is already installed."
    return 0
  fi

  if ! command -v pacman >/dev/null 2>&1; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      cecho YELLOW "pacman not found; previewing yay bootstrap anyway."
    else
      die "pacman not found; cannot install yay."
    fi
  fi

  if ! confirm "Install yay AUR helper?"; then
    cecho YELLOW "Skipped yay installation."
    return 0
  fi

  run sudo pacman -S --needed --noconfirm git base-devel

  local yay_dir
  yay_dir="$(mktemp -d)"
  run git clone https://aur.archlinux.org/yay.git "$yay_dir"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] build yay in $yay_dir"
    echo "[dry-run] remove $yay_dir"
    return 0
  fi

  (cd "$yay_dir" && makepkg -si --noconfirm)
  rm -rf "$yay_dir"
}

install_aur_packages() {
  if ! command -v yay >/dev/null 2>&1; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      cecho YELLOW "yay not found; previewing AUR install command anyway."
    else
      die "yay not found; cannot install AUR packages."
    fi
  fi

  if confirm "Install helper packages with yay?"; then
    run yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
  fi
}

setup_wakafetch() {
  if ! confirm "Install wakafetch-sqlite to /usr/bin?"; then
    cecho YELLOW "Skipped wakafetch-sqlite."
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] download wakafetch-sqlite and install it to /usr/bin"
    return 0
  fi

  local temp_file
  temp_file="$(mktemp)"

  if wget -q "https://raw.githubusercontent.com/ad1822/wakafetch-sqlite/dev/wakafetch-sqlite" -O "$temp_file"; then
    sudo mv "$temp_file" /usr/bin/wakafetch-sqlite
    sudo chmod +x /usr/bin/wakafetch-sqlite
    cecho GREEN "wakafetch-sqlite installed."
  else
    rm -f "$temp_file"
    cecho RED "wakafetch-sqlite download failed."
    return 1
  fi
}

main() {
  cecho CYAN "Hyprdots safe installer"
  cecho BLUE "Source: $DOTS_DIR"
  cecho BLUE "Backup: $BACKUP_DIR"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    cecho MAGENTA "Dry-run mode: no files will be changed."
  fi

  preflight
  run mkdir -p "$HOME/Pictures/Wallpaper"

  if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
    install_pacman_packages
    install_yay
    install_aur_packages
  else
    cecho YELLOW "Package install skipped. Re-run with --install-packages to enable it."
  fi

  for module in "${CONFIG_MODULES[@]}"; do
    copy_config_module "$module"
  done

  ensure_hyprpaper_config
  install_web_apps
  enable_system_services
  enable_user_audio_services
  setup_wakafetch
  cecho GREEN "Setup complete."
}

main "$@"
