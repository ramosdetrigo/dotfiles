-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.colors = {
	background = "#11111b",
	tab_bar = {
		background = "#13131E",
	},
}
-- config.font = wezterm.font 'Maple Mono'
config.font = wezterm.font("Maple Mono", { weight = "Light" })
config.font_size = 11.0
config.colors = {
	background = "#000000",
}
config.color_scheme = "Catppuccin Mocha"
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.enable_wayland = true
config.initial_cols = 90
config.initial_rows = 25
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
