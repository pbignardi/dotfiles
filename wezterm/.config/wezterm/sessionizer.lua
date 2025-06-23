local M = {}
local wezterm = require("wezterm")
local nf = wezterm.nerdfonts
local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")

local function findDirsSchema(parent)
	return function()
		local schema = {}
		local fdcommand = {
			"fd",
			".",
			parent,
			"--exact-depth=1",
			"--type=d",
		}

		local success, stdout, stderr = wezterm.run_child_process(fdcommand)
		if not success then
			wezterm.log_error("Command failed: ", fdcommand)
		end

		for line in stdout:gmatch("[^\n]+") do
			local entry = { label = line, id = line }
			table.insert(schema, entry)
		end

		return schema
	end
end

local new_ws = {
	options = {
		prompt = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { AnsiColor = "Blue" } },
			{ Text = nf.cod_multiple_windows .. " Open new session: " },
		}),
	},
	sessionizer.DefaultWorkspace({}),

	-- manual entries
	wezterm.home_dir .. "/dotfiles",

	-- fd children
	findDirsSchema(wezterm.home_dir .. "/projects"),
	findDirsSchema(wezterm.home_dir .. "/Documents"),

	processing = {
		sessionizer.for_each_entry(function(entry)
			entry.label = entry.label:gsub(wezterm.home_dir, "~")
		end),

		sessionizer.for_each_entry(function(entry)
			-- format based on (id features)
			entry.label = nf.cod_folder .. " " .. entry.label
		end),
	},
}

local open_ws = {
	options = {
		prompt = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { AnsiColor = "Green" } },
			{ Text = nf.cod_multiple_windows .. " Switch to session: " },
		}),
	},
	sessionizer.AllActiveWorkspaces({}),
	processing = sessionizer.for_each_entry(function(entry)
		entry.label = entry.label:gsub(wezterm.home_dir, "~")
	end),
}

M.setup = function(config)
	table.insert(config.keys, {
		key = "b",
		mods = "CTRL",
		action = sessionizer.show(new_ws),
	})
	table.insert(config.keys, {
		key = "f",
		mods = "CTRL",
		action = sessionizer.show(open_ws),
	})
end

return M
