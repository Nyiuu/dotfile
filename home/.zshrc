if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

if [[ "$TERM" == "linux" ]]; then
  ZSH_THEME=""
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo extract history-substring-search)

source $ZSH/oh-my-zsh.sh

if [[ "$TERM" == "linux" ]]; then
  PROMPT='%n@%m:%~%# '
  RPROMPT=''
else
  [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
fi

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#928374'
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#ebdbb2'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#fb4934,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#fe8019'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[function]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[command]='fg=#fabd2f'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#83a598'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#928374'
ZSH_HIGHLIGHT_STYLES[path]='fg=#8ec07c,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#928374'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#83a598'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#83a598'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b8bb26'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d3869b'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#8ec07c'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#fe8019'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#928374'

alias vi="nvim"
alias nivm="nvim"
alias vim="nvim"
alias tmux="zellij"
alias lg="lazygit"

export https_proxy=http://127.0.0.1:7897 
export http_proxy=http://127.0.0.1:7897 
export all_proxy=socks5://127.0.0.1:7897
export no_proxy=localhost,127.0.0.1,::1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


function r() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
