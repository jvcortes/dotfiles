-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


local function getOS()
    local osname
	local fh, err = assert(io.popen("uname 2>/dev/null","r"))

	if fh then
		osname = fh:read()
	end

	return osname or "Windows"
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--
if getOS() == 'Linux' then
    config.font = wezterm.font 'FantasqueSansM Nerd Font Mono'
elseif getOS() == 'Darwin' then
    config.font = wezterm.font 'MesloLG Nerd Font Mono'
end

config.font_size = 11
config.color_scheme = 'rose-pine'

config.enable_tab_bar = false
config.window_background_opacity = 0.94

config.initial_cols = 140
config.initial_rows = 34

config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20
}

config.colors = {
    selection_fg = "none",
    selection_bg = "rgba:50% 50% 50% 50%"
}

-- and finally, return the configuration to wezterm
--
return config
