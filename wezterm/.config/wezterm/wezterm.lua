local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- disable tab bar
config.enable_tab_bar = false

-- disable window padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- font configuration
config.font = wezterm.font("MesloLGM Nerd Font Mono")
config.font_size = 15

-- colorscheme configuration
config.color_scheme = "Chalk (base16)"

return config
