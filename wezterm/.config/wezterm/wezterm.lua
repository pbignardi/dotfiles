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
config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font({
	family = "Source Code Pro",
	weight = "Regular",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})
config.font_size = 13
config.line_height = 1.1

-- colorscheme configuration
config.color_scheme = "Chalk (base16)"

return config
