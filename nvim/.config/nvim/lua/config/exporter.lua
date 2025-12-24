-- TODO:
-- - setup function
-- - options
-- - user command

local M = {}

M.opts = {
	target_file = "/home/paolo/.config/wezterm/colors/generated.toml",
}

local data_scheme = {
	ansi = {
		"terminal_color_0",
		"terminal_color_1",
		"terminal_color_2",
		"terminal_color_3",
		"terminal_color_4",
		"terminal_color_5",
		"terminal_color_6",
		"terminal_color_7",
	},
	brights = {
		"terminal_color_8",
		"terminal_color_9",
		"terminal_color_10",
		"terminal_color_11",
		"terminal_color_12",
		"terminal_color_13",
		"terminal_color_14",
		"terminal_color_15",
	},
}

M.colorscheme = {
	name = nil,
	colors = {
		foreground = nil,
		background = nil,
		ansi = {},
		brights = {},
	},
	metadata = {},
}

local function is_array(t)
	if type(t) ~= "table" then
		return nil
	end
	local count = 0
	for k, _ in pairs(t) do
		if type(k) ~= "number" then
			return false
		else
			count = count + 1
		end
	end

	for i = 1, count do
		if not t[i] and type(t[i]) ~= "nil" then
			return false
		end
	end
	return true
end

---Escape basic data for TOML: strings, numbers, arrays, booleans.
---@param data any
---@return string|nil
local function escape_toml(data)
	if type(data) == "string" then
		return string.format('"%s"', data:gsub('"', '\\"'))
	end

	if type(data) == "number" or type(data) == "boolean" then
		return tostring(data)
	end

	if type(data) == "table" then
		if is_array(data) then
			local items = {}
			for _, v in ipairs(data) do
				table.insert(items, escape_toml(v))
			end
			return "[" .. table.concat(items, ", ") .. "]"
		else
			error("Cannot escape table into TOML")
		end
	end
	return nil
end

---Write table `t` to TOML file, using recursive approach for nested tables.
---Supports only the basics of the TOML specification:
--- - strings
--- - numbers
--- - booleans
--- - arrays
--- - tables
---
---NOTE: nested arrays are not supported (and probably never will).
---@param t table
---@param file file*
---@param headers? string
local function write_toml(t, file, headers)
	-- write variables and array from table t
	for key, value in pairs(t) do
		if is_array(value) or type(value) ~= "table" then
			file:write(string.format("%s = %s\n", key, escape_toml(value)))
		end
	end

	-- write tables from t and recurse
	for key, value in pairs(t) do
		if not is_array(value) and type(value) == "table" then
			local sub_header
			if headers ~= nil then
				sub_header = headers .. "." .. key
			else
				sub_header = key
			end
			file:write(string.format("\n[%s]\n", sub_header))
			write_toml(value, file, sub_header)
		end
	end

	-- flush buffer
	file:flush()
end

---Update `M.colorscheme` table with current colorscheme data
M.update_colorscheme = function()
	M.colorscheme.name = vim.g.colors_name or "default"
	local normal_hg = vim.api.nvim_get_hl(0, { name = "Normal" })

	-- set metadata
	M.colorscheme.metadata.name = "NvimGenerated"

	local colors = {}
	-- set fg and bg
	colors.foreground = string.format("#%06x", normal_hg.fg)
	colors.background = string.format("#%06x", normal_hg.bg)

	-- set ansi and bright colors
	colors.ansi = {}
	for _, key in ipairs(data_scheme.ansi) do
		if vim.g[key] == nil then
			error("Trying to access " .. key .. " which is not defined!")
		end
		table.insert(colors.ansi, vim.g[key])
	end

	colors.brights = {}
	for _, key in ipairs(data_scheme.brights) do
		if vim.g[key] == nil then
			error("Trying to access " .. key .. " which is not defined!")
		end
		table.insert(colors.brights, vim.g[key])
	end

	M.colorscheme.colors = colors
end

-- export colorscheme to wezterm colorscheme toml file
M.export = function()
	local file = io.open(M.opts.target_file, "w")
	if file == nil then
		error("Could not open target file " .. M.opts.target_file)
	end
	-- write header
	file:write(string.format("# generated colorscheme - %s\n", M.colorscheme.name))

	-- write table to toml
	write_toml(M.colorscheme, file)
end

M.setup = function(opts)
	opts = opts or {}
	-- extend option table
	M.opts = vim.tbl_extend("force", M.opts, opts)

	-- assert M.opts.target_file is defined
	if M.opts.target_file == nil then
		error("`M.opts.target_file` is not defined in `opts`!")
	end

	-- define the export colorscheme command
	vim.api.nvim_create_user_command("ExportColorscheme", function(_)
        M.update_colorscheme()
		M.export()
	end, {})
end

M.setup()
