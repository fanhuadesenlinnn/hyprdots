<h1 align="center">🫟 Hyprdots</h1>

<div align="center">
<p>
<a href="https://github.com/ad1822/hyprdots/stargazers"><img src="https://img.shields.io/github/stars/ad1822/hyprdots?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=C9CBFF&labelColor=302D41" alt="stars"><a>&nbsp;&nbsp;
<!-- <a href="https://github.com/ad1822/hyprdots/"><img src="https://img.shields.io/github/repo-size/ad1822/hyprdots?style=for-the-badge&logo=hyprland&logoColor=f9e2af&label=Size&labelColor=302D41&color=f9e2af" alt="REPO SIZE"></a>&nbsp;&nbsp; -->
<a href="https://github.com/ad1822/hyprdots/"><img src="https://img.shields.io/github/forks/ad1822/hyprdots?style=for-the-badge&logo=appveyor&logoColor=f9e2af&label=Forks&labelColor=302D41&color=f9e2af" alt="REPO SIZE"></a>&nbsp;&nbsp;
<a href="https://github.com/ad1822/hyprdots/commits/main/"><img src="https://img.shields.io/github/last-commit/ad1822/hyprdots?style=for-the-badge&logo=github&logoColor=eba0ac&label=Last%20Commit&labelColor=302D41&color=eba0ac" alt="Last Commit"></a>&nbsp;&nbsp;
<a href="https://github.com/ad1822/hyprdots/blob/main/LICENSE"><img src="https://img.shields.io/github/license/ad1822/hyprdots?style=for-the-badge&logo=&color=CBA6F7&logoColor=CBA6F7&labelColor=302D41" alt="LICENSE"></a>&nbsp;&nbsp;
</p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png" width="400" />
</p>
<!-- <p align="center">
  <a href="https://github.com/zemmsoares/awesome-rices">
    <img src="https://raw.githubusercontent.com/zemmsoares/awesome-rices/main/assets/awesome-rice-badge.svg" alt="awesome-rice-badge">
  </a>
</p> -->

<div align="center">
  <img src="Assets/main.png" alt="main" width="100%"/>
</div>

<div align="center">
  <img src="Assets/launcher.png" alt="launcher" width="49%"/>
  <img src="Assets/powermenu.png" alt="powermenu" width="49%"/>
</div>


<div align="center">
  <img src="Assets/wallpicker.png" alt="wallpaper rofi" width="49%"/>
  <img src="Assets/gitlog.png" alt="git log" width="49%"/>
</div>

<div align="center">
  <img src="Assets/nvim-obs.png" alt="obs nvim" width="100%"/>
</div>

<div align="center">
  <img src="Assets/player.png" alt="player" width="100%"/>
</div>

<div align="center">
  <img src="Assets/btop.png" alt="btop" width="100%"/>
</div>

<div align="center">
  <img src="Assets/nvim.png" alt="nvim" width="100%"/>
</div>

<div align="center">
  <img src="Assets/github.png" alt="github" width="100%"/>
</div>

<div align="center">
  <img src="Assets/yazi.png" alt="yazi" width="100%"/>
</div>

#### My old rice

Change branch of this repo to `old-dotfiles` 
```bash
git checkout old-dotfiles
```

## Wallpapers (Google Drive)

[Wallpapers](https://drive.google.com/drive/folders/1Q1j-Qzx1cU1X8j4xUPrssxn1rgJSnDQO)

---

## 🚀 Quick Installation Guide

### 📦 Programs Included

- **Window Manager**: Hyprland (Tiling)
- **Status Bar**: Waybar
- **Notification Manager**: Dunst
- **Browser**: Google Chrome
- **Input Method**: Fcitx5 + Rime
- **Terminal Emulator**: kitty
- **File Manager**: yazi
- **Notes**: Obsidian
- **Color Picker**: hyprpicker
- **Wallpaper Utility**: hyprpaper
- **Screenshot Utility**: grim + slurp
- **App Launcher**: Rofi
- **Shell**: Fish
- **Media Controls**: playerctl
- **Power Management**: acpi
- **Brightness Control**: brightnessctl
- **Audio Management**: PipeWire, WirePlumber, pamixer
- **Network Management**: NetworkManager (nmcli)

> ℹ️ **For more detailed guidance**, check out [this](./Resources.md)

---

## 🛠️ Installation Steps

1. **Clone the repository** to your home directory like `~` or `/home/username` :

   ```sh
   git clone https://github.com/ad1822/hyprdots ~/hyprdots
   ```

2. **Navigate to the cloned directory**:

   ```sh
   cd ~/hyprdots
   ```

3. **Preview the setup script**:

   ```sh
   bash ./setup.sh --dry-run --yes --install-packages
   ```

4. **Run the one-shot Arch desktop installer**:

   ```sh
   bash ./setup.sh --yes --install-packages
   ```

   This path is intended for a minimal Arch Linux install with a normal user that has sudo access and working internet. It installs the Hyprland desktop packages, bootstraps yay for Chrome, copies the selected dotfiles, installs web app launchers, and enables NetworkManager, Bluetooth, SDDM, and PipeWire for the next boot.

   To copy dotfiles only without installing packages, run `bash ./setup.sh`.

5. **GTK Theme Setup**:

- [Catppuccin Gtk theme](https://github.com/catppuccin/gtk/releases)

- I use [`ngw-look`](https://github.com/nwg-piotr/nwg-look) to configure GTK themes and styles.

---

## ⚠️ Important Notice (Read Before Running Setup)

> ### **Warning:**
>
> This setup script will ask before installing each config module. Existing config directories are moved to a timestamped backup folder at `~/.config_backup`, then the selected configs are copied from this repo into `~/.config`.
>
> ### What this means:
>
> - Use `bash ./setup.sh --dry-run` first to preview file changes.
> - Package installation is skipped unless you pass `--install-packages`.
> - The one-shot path still assumes you already created a non-root user with sudo access during Arch installation.
> - Waybar's GitHub `.env` file is created only if it does not already exist.
> - If you have customizations you care about, review the script and keep your own backup before running.

---

<p align="center">
  <img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" />
</p>

---

## My Workflow

>- My setup remaps Caps Lock → Super (⌘) for faster window management and command access.
>- You can change this behavior in your Hyprland input configuration if you prefer the default key layout.
>- You can also enable animation in `hyprland`, My configuration have animation, but I have been not fan of animation

## Keybindings

| Shortcut                       | Action                                                      |
| ------------------------------ | ----------------------------------------------------------- |
| **`⌘ + T`**             | Open terminal                                               |
| **`⌘ + B`**             | Launch browser                                              |
| **`⌘ + W`**             | Close active window                                         |
| **`⌘ + V`**             | Toggle floating mode                                        |
| **`⌘ + F`**             | Enable fullscreen (mode 1)                                  |
| **`⌘ + G`**             | Disable fullscreen (mode 0)                                 |
| **`⌘ + N`**             | Launch floating Neovim Anywhere window                      |
| **`⌘ + O`**             | Launch Obsidian                                             |
| **`⌘ + E`**             | Open file manager in terminal                               |
| **`⌘ + P`**             | Open Rofi power menu (Rofi)                                        |
| **`⌘ + Space`**         | Launch Rofi app launcher (Rofi)                                   |
| **`⌘ + Shift + R`**     | Open wallpaper selector and reload Hyprpaper                |
| **`⌘ + Shift + S`**     | Take area screenshot using Grim & Slurp (copy to clipboard) |
| **`Print`**                    | Take area screenshot and save with Grimblast                |
| **`Alt + Shift + S`**          | Run custom screenshot script                                |
| **`Alt + Shift + W`**          | Restart Waybar                                              |
| **`Ctrl + Shift + Tab`**       | Open task manager in terminal                               |
| **`⌘ + C`**             | Launch color picker                                         |
| **`⌘ + I`**             | Change wallpaper and reload Hyprpaper                       |
| **`⌘ + M`**             | Launch Rofi clipboard manager (Rofi)                              |
| **`⌘ + Shift + L`**     | Lock screen using Hyprlock                                  |
| **`⌘ + A`**             | Launch Rofi Wi-Fi selector (Rofi)                                  |
| **`Alt + Tab`**                | Cycle to next window                                        |
| **`Alt + Shift + Tab`**        | Cycle to previous window                                    |
| **`⌘ + Tab`**           | Bring active window to top                                  |
| **`⌘ + H / J / K / L`** | Move focus (left / down / up / right)                       |

### Workspace Management

| Shortcut                       | Action                                          |
| ------------------------------ | ----------------------------------------------- |
| **`⌘ + 1–6`**           | Switch to workspace 1–6                         |
| **`⌘ + 0 / 9 / 8 / 7`** | Alternate workspace mapping (custom preference) |
| **`⌘ + Shift + [1–0]`** | Move active window to workspace 1–10            |

---

## Tmux Workflow

> **Prefix key:** `Ctrl + A`
> To enable these shortcuts, clone my **dotsh** repository containing all the custom scripts:

```bash
git clone https://github.com/ad1822/dotsh.git ~/work/main/dotsh
```

After cloning, update the paths in your Tmux configuration if your directory structure differs.

| Shortcut       | Description                                                                    |
| -------------- | ------------------------------------------------------------------------------ |
| **Prefix + i** | Launch *fzf-based cheatsheat* (`~/work/main/dotsh/fzf/ch`)                |
| **Prefix + t** | Open *fzf Tmux session switcher* (`~/work/main/dotsh/fzf/tmux-session`)        |
| **Prefix + d** | Edit dotfiles via *fzf-based selector* (`~/work/main/dotsh/fzf/edit-dotfiles`) |
| **Prefix + m** | Open *[mpterm](https://github.com/ad1822/mpterm)* — a minimal music player terminal                                r

---
