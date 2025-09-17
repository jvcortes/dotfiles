#!/bin/sh

rofi -monitor $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name' -r) -show drun 
