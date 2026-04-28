# dotfile

Personal dotfiles for zsh, niri, Neovim, zellij, yazi, alacritty, and related tools.

## Layout

- `home/` maps to `$HOME`
- `config/` maps to `${XDG_CONFIG_HOME:-$HOME/.config}`
- `scripts/install.sh` creates symlinks and backs up existing files into `backups/`

Current tracked configs:

- `home/.zshrc`
- `home/.p10k.zsh`
- `config/niri/config.kdl`
- `config/nvim/init.lua`
- `config/nvim/nvim-pack-lock.json`
- `config/zellij/config.kdl`

`config/yazi/` and `config/alacritty/` are present as placeholders because no local configs were found yet.

## Install

```sh
./scripts/install.sh
```

The script is idempotent for links it already manages. If a target file already exists, it is moved into `backups/<timestamp>/` before the symlink is created.

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
