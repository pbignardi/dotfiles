local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

local is_high_density = function(screen)
	return screen.effective_dpi >= 144
end

-- disable tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false

-- disable window padding
config.window_padding = {
	left = 0,
	right = 0, top = 0,
	bottom = 0,
}

local fontsize_setters = {
	ref_dpi = function(target)
		if target == nil then
			target = 16
		end
		return function(window)
			-- fontsize referenced on 72 DPI display
			local ref_fs = target

			local active = wezterm.gui.screens().active
			local dpi = active.effective_dpi

			if is_high_density(active) then
				dpi = dpi / 2
			end

			-- compute font size based on the screen dpi
			window:set_config_overrides({
				font_size = math.ceil(ref_fs * 72 / dpi),
			})
		end
	end,
	line_nr = function(target)
		if target == nil then
			target = 70
		end
		return function(window)
			-- compute fontsize so that fixed number of lines are visible
			local target_linenr = target

			local active = wezterm.gui.screens().active
			local line_height = active.height / target_linenr

			window:set_config_overrides({
				font_size = math.ceil(line_height * 72 / active.effective_dpi),
			})
		end
	end,
}

-- update font-size based on dpi settings
wezterm.on("window-config-reloaded", fontsize_setters.ref_dpi(17))

-- font configuration
config.adjust_window_size_when_changing_font_size = false
config.font_size = 13
-- config.font = wezterm.font("IosevkaTerm Nerd Font")
config.font = wezterm.font("AdwaitaMono Nerd Font")

-- colorscheme configuration
local custom_colorschemes = require("colorschemes")
custom_colorschemes.set_custom_colorscheme(config, "OneDark")
config.colors = {
	cursor_bg = "#eb7134",
	cursor_border = "#eb7134",
}

wezterm.on("update-right-status", function(window, pane)
	local workspace = wezterm.mux.get_active_workspace()
	local domain = wezterm.mux.get_domain()
	window:set_right_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = "White" } },
		{ Background = { AnsiColor = "Grey" } },
		{ Text = " " .. domain:name() .. " " },
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = "Black" } },
		{ Background = { AnsiColor = "Blue" } },
		{ Text = "  " .. workspace .. " " },
	}))
end)

-- specify wsl on windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_domain = "WSL:Debian"
else
	config.default_domain = "unix"
end

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle) },
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

return config
