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

-- specify font-size on retina display
wezterm.on("window-config-reloaded", function(window)
	if wezterm.gui.screens().active.name == "Built-in Retina Display" then
		window:set_config_overrides({
			font_size = 14,
		})
	end
end)

-- font configuration
config.adjust_window_size_when_changing_font_size = false
config.font_size = 13

-- colorscheme configuration
config.color_scheme = "Chalk (base16)"

return config
