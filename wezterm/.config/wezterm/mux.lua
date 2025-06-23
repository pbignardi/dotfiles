local M = {}

local wezterm = require("wezterm")
local nf = wezterm.nerdfonts
local action = wezterm.action

local mux_keys = {
	{ key = "=", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "c", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = "LEADER", action = action.CloseCurrentPane({ confirm = false }) },
	{ key = "1", mods = "LEADER", action = action.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = action.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = action.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = action.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = action.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = action.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = action.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = action.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = action.ActivateTab(8) },
	{ key = "[", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "a", mods = "LEADER", action = wezterm.action.AttachDomain("unix") },
	{ key = "d", mods = "LEADER", action = wezterm.action.DetachDomain({ DomainName = "unix" }) },
}

M.setup = function(config)
	-- general config
	config.leader = { key = "Space", mods = "CTRL", timout_milliseconds = 2000 }
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true

	-- setup multiplexer sockets
	config.unix_domains = {
		{ name = "unix" },
	}

	-- set keys
	if config.keys == nil then
		config.keys = {}
	end
	for _, k in ipairs(mux_keys) do
		table.insert(config.keys, k)
	end
end

wezterm.on("update-right-status", function(window, pane)
	-- local success, date, stderr = wezterm.run_child_process({ "date" })
	local time = wezterm.strftime("%H:%M")
	local ws_name = window:active_workspace()
	if ws_name == "default" then
	else
		ws_name = ws_name:gsub("\\", "/"):match("^/*(.-)/*$"):match("[^/]*/([^/]*)$")
	end
	local domain = pane:get_domain_name()

	window:set_right_status(wezterm.format({
		{ Foreground = { AnsiColor = "Aqua" } },
		{ Background = { AnsiColor = "Black" } },
		{ Text = " " .. time .. " " },
		"ResetAttributes",
		{ Attribute = { Intensity = "Half" } },
		{ Background = { AnsiColor = "Blue" } },
		{ Foreground = { AnsiColor = "Black" } },
		{ Text = " " .. nf.cod_remote .. " " .. domain .. " " },
	}))

	window:set_left_status(wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { AnsiColor = "Purple" } },
		{ Background = { AnsiColor = "Black" } },
		{ Text = "  " .. ws_name .. " " },
	}))
end)

local function tab_name(tab)
	local process = tab.active_pane.foreground_process_name
	return process or ""
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = ""
	local tab_index = tab.tab_index + 1
	if tab.is_active then
		return wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { AnsiColor = "Green" } },
			{ Background = { AnsiColor = "Black" } },
			{ Text = " " .. tab_index .. " " .. tab_name(tab) .. " " },
		})
	end
	title = wezterm.format({
		{ Foreground = { AnsiColor = "Grey" } },
		{ Background = { AnsiColor = "Black" } },
		{ Text = " " .. tab_index .. " " .. tab_name(tab) .. " " },
	})

	return title
end)

return M
