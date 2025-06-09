local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_high_density = function(screen)
	return screen.effective_dpi >= 144
end

-- disable tab bar
config.enable_tab_bar = false

-- disable window padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

local fontsize_setters = {
	ref_dpi = function(window)
		-- fontsize referenced on 72 DPI display
		local ref_fs = 16

		local active = wezterm.gui.screens().active
		local dpi = active.effective_dpi

		if is_high_density(active) then
			dpi = dpi / 2
		end

		-- compute font size based on the screen dpi
		window:set_config_overrides({
			font_size = math.ceil(ref_fs * 72 / dpi),
		})
	end,
	line_nr = function(window)
		-- compute fontsize so that fixed number of lines are visible
		local target_linenr = 70

		local active = wezterm.gui.screens().active
		local line_height = active.height / target_linenr

		window:set_config_overrides({
			font_size = math.ceil(line_height * 72 / active.effective_dpi),
		})
	end,
}

-- update font-size based on dpi settings
wezterm.on("window-config-reloaded", fontsize_setters.ref_dpi)

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
