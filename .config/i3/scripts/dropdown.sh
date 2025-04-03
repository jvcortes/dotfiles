#!/bin/sh

APPLICATION=$1

case $APPLICATION in
	terminal)
		i3-msg "[class="dropdown"] scratchpad show; [class="dropdown"] move position center" ||  setsid st -c dropdown -e zsh &
		;;
	keepassxc)
		i3-msg "[instance="keepassxc"] scratchpad show; [class="keepassxc"] move position center" ||  setsid keepassxc &
		;;
esac

