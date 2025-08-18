local wezterm = require("wezterm")
local M = {}

local generators = {}

-- functions
local function darken_black(color_scheme)
	color_scheme.brights[1] = color_scheme.ansi[1]
	color_scheme.ansi[1] = color_scheme.background
	return color_scheme
end

M.color_schemes = {
	["Chalk"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["Chalk (base16)"]
			return cs
		end,
	},
	["Moonfly"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["Moonfly (Gogh)"]
			cs = darken_black(cs)
			return cs
		end,
	},
	["XCodeHC"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["XCode Dusk"]
			return cs
		end,
	},
	["OneDark"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["OneDark (base16)"]
			local background = "#232326"
			cs.ansi[1] = background
			cs.background = background
			return cs
		end,
	},
	["Gruvbox Material"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["Gruvbox Material (Gogh)"]
			return cs
		end,
	},
	["Srcery"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["Srcery (Gogh)"]
			return cs
		end,
	},
	["Sonokai"] = {
		config = function()
			local cs = wezterm.color.get_builtin_schemes()["Sonokai (Gogh)"]
			return cs
		end,
	},
}

-- TODO
-- dasupradyumna/midnight.nvim,
-- "scottmckendry/cyberdream.nvim",

function M.set_custom_colorscheme(config, color_scheme)
	for index, value in pairs(M.color_schemes) do
		if index == color_scheme then
			config.color_schemes = { [index] = value.config() }
			config.color_scheme = index
			break
		end
	end
end

return M
