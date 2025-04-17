-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.colors = {
  background = "#11111b",
  tab_bar = {
    background = "#13131E",
  }
}
config.font = wezterm.font 'Victor Mono'
config.color_scheme = 'Catppuccin Mocha'
config.enable_scroll_bar = true
config.use_fancy_tab_bar = false
config.initial_cols = 87
config.initial_rows = 23
config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

-- and finally, return the configuration to wezterm
return config
