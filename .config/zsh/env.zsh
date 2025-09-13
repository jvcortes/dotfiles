export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
export BROWSER="$(which firefox)"
export PATH="$HOME/scripts:$HOME/.local/bin:$HOME/.node_modules/bin:$HOME/.go/bin:$HOME/.pyenv/bin:$HOME/.cargo/bin:$HOME/.config/emacs/bin:$HOME/.config/scan/scripts/:$PATH"
export NVIM_APPNAME='nvim'

export npm_config_prefix=~/.node_modules

# Colors for less and man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r


if [ "$(uname -r)" = "Darwin" ]; then
    if [ -d "$(brew --prefix)/opt/grep/libexec/gnubin" ]; then
        PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
    fi
fi
