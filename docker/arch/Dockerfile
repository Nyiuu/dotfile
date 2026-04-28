FROM archlinux:latest

WORKDIR /dotfiles

COPY scripts/install-deps-arch.sh scripts/install-deps-arch.sh
COPY scripts/install.sh scripts/install.sh
COPY home home
COPY config config

RUN pacman -Syu --needed --noconfirm git sudo bash && \
    DOTFILES_SKIP_AUR=1 DOTFILES_SKIP_EXTERNAL=1 bash scripts/install-deps-arch.sh && \
    useradd -m -G wheel tester && \
    printf '%%wheel ALL=(ALL:ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/wheel

USER tester
ENV HOME=/home/tester
ENV XDG_CONFIG_HOME=/home/tester/.config

RUN bash scripts/install.sh && \
    test -L "$HOME/.zshrc" && \
    test -L "$HOME/.config/nvim" && \
    test -L "$HOME/.config/niri" && \
    test -L "$HOME/.config/zellij" && \
    test -L "$HOME/.config/waybar"
