if [[ $# -ne 1 ]]; then
  >&2 echo "usage: $0 FILENAME"
  exit 1
fi

display_img () {

  if [[ $type =~ application/pdf ]]; then
    pdftoppm "$file" "/tmp/fzf_pdf" -r 100 -png -singlefile
    file="/tmp/fzf_pdf.png"
  fi

  dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
  if [[ $dim = x ]]; then
    dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
  elif ! [[ $KITTY_WINDOW_ID ]] && (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
    # Avoid scrolling issue when the Sixel image touches the bottom of the screen
    # * https://github.com/junegunn/fzf/issues/2544
    dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
  fi
  
  # 1. Use chafa with Sixel output
  if command -v chafa > /dev/null; then
    chafa -f sixel -s "$dim" "$file"
    # Add a new line character so that fzf can display multiple images in the preview window
    echo
  
  # 3. If chafa is not found but imgcat is available, use it on iTerm2
  elif command -v imgcat > /dev/null; then
    # NOTE: We should use https://iterm2.com/utilities/it2check to check if the
    # user is running iTerm2. But for the sake of simplicity, we just assume
    # that's the case here.
    imgcat -W "${dim%%x*}" -H "${dim##*x}" "$file"
  
  # 4. Cannot find any suitable method to preview the image
  else
    file "$file"
  fi
}

file=${1/#\~\//$HOME/}
type=$(file --mime-type --dereference -- "$file")

case "$type" in
 *inode/directory*)
  if command -v tree > /dev/null; then
    tree -c "$file" | head -n 200
    exit
  else
    ls -l "$file"
  fi
  ;;
(*image/*|*/pdf*)
  display_img "$file"
  exit
  ;;
 *binary)
  file "$file"
  exit
  ;;
 *)
  if command -v batcat > /dev/null; then
    batname="batcat"
  elif command -v bat > /dev/null; then
    batname="bat"
  else
    cat "$file"
    exit
  fi

  ${batname} --style=header,plain --color=always --pager=never -- "$file"
  exit
esac
