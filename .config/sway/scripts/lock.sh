#!/bin/sh

if [ -f "/usr/local/bin/swaylock" ]; then
	swaylock -f \
	--clock \
	--effect-vignette 0.3:0.3 \
	--fade-in 0.2 \
	--effect-blur 2x3 -i ~/.config/lockscreen
else
	echo "swaylock is not installed"
fi;
