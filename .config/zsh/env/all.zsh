export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
export BROWSER="$(which firefox)"
export PATH="$HOME/scripts:$HOME/.local/bin:$HOME/.node_modules/bin:$HOME/.go/bin:$HOME/.pyenv/bin:$HOME/.cargo/bin:$HOME/.config/emacs/bin:$PATH"

export npm_config_prefix=~/.node_modules
export LS_COLORS='di=32:ln=36:so=37;41:pi=33:ex=1;30:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'

# Colors for less and man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r
