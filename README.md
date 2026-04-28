# dotfile

Personal dotfiles for zsh, niri, Neovim, zellij, yazi, alacritty, waybar, and related tools.

## Layout

- `home/` maps to `$HOME`
- `config/` maps to `${XDG_CONFIG_HOME:-$HOME/.config}`
- `scripts/install.sh` creates symlinks and backs up existing files/directories into `backups/`

Current tracked configs:

- `home/.zshrc`
- `home/.p10k.zsh`
- `config/niri/config.kdl`
- `config/nvim/init.lua`
- `config/nvim/nvim-pack-lock.json`
- `config/zellij/config.kdl`

`config/yazi/`, `config/alacritty/`, and `config/waybar/` are present as placeholders because no local configs were found yet.

## Install

Install Arch Linux dependencies:

```sh
./scripts/install-deps-arch.sh
```

Set `DOTFILES_SKIP_AUR=1` to skip AUR/third-party packages, and `DOTFILES_SKIP_EXTERNAL=1` to skip GitHub clones for Oh My Zsh plugins/themes.

Link dotfiles:

```sh
./scripts/install.sh
```

The script is idempotent for links it already manages. Files in `home/` are linked individually. Top-level directories in `config/` are linked as whole config directories, for example `~/.config/nvim -> config/nvim`. If a target already exists, it is moved into `backups/<timestamp>/` before the symlink is created.

## Docker Test

```sh
docker build -f docker/arch/Dockerfile .
```

The Docker image validates the Arch official repository dependencies and checks that the dotfile symlinks can be created. AUR/third-party packages such as `waypaper`, `niriswitcher`, and `clash-verge-rev` are intentionally skipped in Docker.

## First Push To GitHub

```sh
git init
git add .
git commit -m "Initial dotfiles"
git branch -M main
git remote add origin git@github.com:<user>/<repo>.git
git push -u origin main
```

Replace `<user>/<repo>` with your GitHub repository path.
