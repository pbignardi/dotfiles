local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

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
	{ name = "mux" },
}

config.default_domain = "mux"

-- TODO:
-- define `base` as the default workspace, the one you are on as you

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
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "a", mods = "LEADER", action = act.AttachDomain("mux") },
	{ key = "d", mods = "LEADER", action = act.DetachDomain({ DomainName = "mux" }) },
	-- navigation stuff
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "f", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	-- { key = "b", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS" }) },
	{ key = "d", mods = "CTRL", action = act.ShowLauncherArgs({ flags = "DOMAINS" }) },
	{ key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
}
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

wezterm.on("update-status", function(window, pane)
	-- Make it italic and underlined
	window:set_right_status(wezterm.format({
		-- display the current domain
		{ Foreground = { AnsiColor = "White" } },
		{ Text = " " .. wezterm.mux.get_domain():name() .. " " },
		-- display the current workspace
		{ Background = { AnsiColor = "Green" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. wezterm.mux.get_active_workspace() .. " " },
	}))
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane_is_zoomed then
		zoomed = "[Z]"
	end

	return zoomed .. tab.active_pane.title
end)

-- INFO: The following is the project directories to search
local projects = {
	"C:/Repos",
}

-- font configuration
config.adjust_window_size_when_changing_font_size = false
config.font_size = 13
config.font = wezterm.font("CaskaydiaCove NF")

return config
