local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

-- disable window padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- multiplexer configuration
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true

-- define unix domain for multiplexing
config.unix_domains = {
	{ name = "multiplexer" },
}

-- config.default_domain = "standard"

config.leader = {
	key = "Space",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	-- tmux-like keybindings
	{ key = "f", mods = "ALT", action = act.TogglePaneZoomState },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "a", mods = "LEADER", action = act.AttachDomain("multiplexer") },
	{ key = "d", mods = "LEADER", action = act.DetachDomain({ DomainName = "multiplexer" }) },
	-- switch tab
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
	-- navigation stuff
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "f", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	-- { key = "b", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS" }) },
	{ key = "d", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },
	{ key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
}

config.bold_brightens_ansi_colors = false

wezterm.on("update-status", function(window, pane)
	local domain = wezterm.nerdfonts.cod_remote .. " " .. pane:get_domain_name()
	local ws = wezterm.nerdfonts.cod_terminal_tmux .. " " .. wezterm.mux.get_active_workspace() -- Make it italic and underlined
	window:set_right_status(wezterm.format({
		-- display the current domain
		{ Foreground = { AnsiColor = "White" } },
		{ Text = " " .. domain .. " " },
		-- display the current workspace
		{ Background = { AnsiColor = "Olive" } },
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. ws .. " " },
	}))
end)

wezterm.on("gui-startup", function(cmd)
	wezterm.mux.spawn_window(cmd or {})
end)

local function tab_title(t)
	local stop = string.find(t.active_pane.title, " ")
	local proc = string.sub(t.active_pane.title, 1, stop)
	local indicator = "-"
	local intensity = "Normal"
	local fgcolor = "Grey"
	local accent = "Grey"

	if t.is_active then
		indicator = "*"
		intensity = "Bold"
		fgcolor = "White"
		accent = "Red"
	end

	return wezterm.format({
		{ Attribute = { Intensity = intensity } },
		{ Foreground = { AnsiColor = accent } },
		{ Text = " " .. tostring(t.tab_index + 1) },
		{ Foreground = { AnsiColor = fgcolor } },
		{ Text = ":" .. proc .. indicator .. " " },
	})
end

config.colors = {
	tab_bar = {
		background = "Blue",
		active_tab = {
			bg_color = "Black",
			fg_color = "White",
		},
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	return title
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane_is_zoomed then
		zoomed = "[Z]"
	end

	return zoomed .. tab.active_pane.title
end)

-- INFO: The following is the project directories to search
config.color_scheme = "OneDark (base16)"

-- font configuration
config.adjust_window_size_when_changing_font_size = false
config.font_size = 13
config.font = wezterm.font("CaskaydiaMono Nerd Font")

return config
