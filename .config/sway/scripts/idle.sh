#!/bin/sh

if [ -f "/usr/bin/swayidle" ]; then
	swayidle \
		timeout 300 '~/.config/sway/scripts/lock.sh' \
		timeout 480 'systemctl suspend' \
		resume 'swaymsg reload'
else
	echo "swayidle is not installed"
fi;
