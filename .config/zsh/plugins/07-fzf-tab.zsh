znap source Aloxaf/fzf-tab

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:toggle+down'
zstyle ':fzf-tab:*' accept-line ctrl-l
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*:descriptions' format '[%d]'
