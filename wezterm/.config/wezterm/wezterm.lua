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

local monitor_specific_config = {
	-- Built-in retina display on Mac
	{
		identify = function()
			if wezterm.gui.screens().active.name == "Built-in Retina Display" then
				return true
			else
				return false
			end
		end,
		config = {
			font_size = 14,
		},
	},
	-- 2K ultrawide monitor
	{
		identify = function()
			return wezterm.gui.screens().active.height == 1440 and wezterm.gui.screens().active.width == 3440
		end,
		config = {
			font_size = 16,
		},
	},
	-- 2k monitor
	{
		identify = function()
			return wezterm.gui.screens().active.height == 1440 and wezterm.gui.screens().active.width == 2560
		end,
		config = {
			font_size = 16,
		},
	},
	-- 1080p monitor
	{
		identify = function()
			return wezterm.gui.screens().active.width == 1080 and wezterm.gui.screens().active.width == 1920
		end,
		config = {
			font_size = 15,
		},
	},
}

-- specify font-size on retina display
wezterm.on("window-config-reloaded", function(window)
	for _, monitor in ipairs(monitor_specific_config) do
		if monitor.identify() then
			window:set_config_overrides(monitor.config)
		end
	end
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
