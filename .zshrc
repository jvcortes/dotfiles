zmodload zsh/zprof

source $HOME/.config/zsh/znap/znap.zsh
source $HOME/.config/zsh/aliases.zsh

znap prompt sindresorhus/pure
 
setopt correct
setopt nocheckjobs
setopt numericglobsort
setopt nobeep
setopt inc_append_history
setopt histignorealldups
setopt hist_ignore_space
setopt autocd

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
 
WORDCHARS=${WORDCHARS//\/[&.;_-]}
 
bindkey -v
bindkey '^v' edit-command-line
bindkey -M viins jk vi-cmd-mode

source $HOME/.config/zsh/env_variables.zsh
source $HOME/.config/zsh/keybindings.zsh
source $HOME/.config/zsh/functions.zsh

for file in $HOME/.config/zsh/plugins/*.(zsh|bash); do
  source "$file"
done

