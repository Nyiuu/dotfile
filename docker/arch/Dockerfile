FROM archlinux:latest

ARG http_proxy
ARG https_proxy
ARG all_proxy
ARG no_proxy
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG ALL_PROXY
ARG NO_PROXY

WORKDIR /dotfiles

COPY scripts/install-deps-arch.sh scripts/install-deps-arch.sh
COPY scripts/install.sh scripts/install.sh
COPY home home
COPY config config

RUN printf 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch\n' > /etc/pacman.d/mirrorlist && \
    printf 'DisableDownloadTimeout\n' >> /etc/pacman.conf

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
