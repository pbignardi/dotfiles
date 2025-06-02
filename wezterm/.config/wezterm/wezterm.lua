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

-- fontsize referenced on 96 DPI display
local ref_fontsize = 13
local ref_dpi = 96

-- update font-size based on dpi settings
wezterm.on("window-config-reloaded", function(window)
	local active = wezterm.gui.screens().active
	local dpi = active.effective_dpi
	local fontsize = math.ceil(ref_fontsize * ref_dpi / dpi)

	window:set_config_overrides({
		font_size = fontsize,
	})
end)

-- font configuration
config.adjust_window_size_when_changing_font_size = false
config.font_size = 13

-- colorscheme configuration
config.color_scheme = "Chalk (base16)"

-- specify wsl on windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:archlinux"
end

return config
