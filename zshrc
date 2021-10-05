eval $(keychain -q --eval id_rsa)

setopt correct
setopt nocheckjobs
setopt numericglobsort
setopt nobeep
setopt inc_append_history
setopt histignorealldups
setopt autocd

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export TERMINAL="/usr/local/bin/st"
export BROWSER="/usr/bin/firefox"
export TERM="st-256color"
export PATH="$HOME/scripts:$HOME/.local/bin:$HOME/.node_modules/bin:$HOME/.go/bin:$HOME/.pyenv/bin:$PATH"
export npm_config_prefix=~/.node_modules

WORDCHARS=${WORDCHARS//\/[&.;_-]}                                 # Don't consider certain characters part of the word

# Colors for less and man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;30m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

bindkey -v
export TIMEOUT=1

autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

### Zinit
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

export WORKON_HOME=$HOME/.virtualenvs
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
source $HOME/.local/bin/virtualenvwrapper_lazy.sh

source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/keybindings.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
