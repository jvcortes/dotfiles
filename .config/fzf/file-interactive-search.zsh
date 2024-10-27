#!/bin/zsh

##
# Interactive search.
# Usage: `ff` or `ff <folder>`.
#
#
file_interactive_search () {
  RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"
  
  local selection=( "${(@f)$(FZF_DEFAULT_COMMAND="rg --files" fzf \
    -m \
    -e \
    --ansi \
    --disabled \
    --reverse \
    --bind "ctrl-a:select-all" \
    --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
    --preview "rg -i --pretty --context 2 {q} {}" < "$TTY" | cut -d":" -f1,2)}" )

  LBUFFER+="$selection"
}

zle -N file_interactive_search

bindkey -M viins '^k' file_interactive_search
