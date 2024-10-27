[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --glob "!.git"'
export FZF_COMPLETION_TRIGGER='##'
export FZF_COMPLETION_OPTS='--border'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--multi
--color=fg:8,hl:4
--color=fg+:7,bg+:-1,hl+:4,preview-fg:7
--color=info:1,prompt:1,pointer:3
--color=marker:5,spinner:7,header:8
--prompt='> '"

export FZF_CTRL_R_OPTS="
  --border=sharp
  --preview 'echo {}'
  --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
"

export FZF_CTRL_T_OPTS="
  --border=sharp
  --preview '$HOME/.config/fzf/fzf-preview.zsh {}'
  --preview-window 'right:40%'
  --color header:italic
  --height 80%
"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)              fzf --preview 'tree -c -C {} | head -200'    "$@" ;;
    export|unset)    fzf --preview "eval 'echo \$'{}"             "$@" ;;
    ssh)             fzf --preview 'dig {}'                       "$@" ;;
    *)               fzf                                          "$@" ;;
  esac
}

source $HOME/.config/fzf/fzf-git.sh
source $HOME/.config/fzf/file-interactive-search.zsh
