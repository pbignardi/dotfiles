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
	["XCodeDarkHC"] = {
		config = function()
			local colors = {
				foreground = "#ffffff",
				background = "#1f1f24",
				cursor_bg = "#ffffff",
				cursor_fg = "#1f1f24",
				cursor_border = "#ffffff",
				selection_fg = "#ffffff",
				selection_bg = "#43454b",
				scrollbar_thumb = "#222222",
				split = "#444444",
				ansi = {
					"#1f1f24",
					"#ff8a7a",
					"#83c9bc",
					"#d9c668",
					"#4ec4e6",
					"#ff85b8",
					"#cda1ff",
					"#ffffff",
				},
				brights = {
					"#838991",
					"#ff8a7a",
					"#b1faeb",
					"#ffa14f",
					"#6bdfff",
					"#ff85b8",
					"#e5cfff",
					"#ffffff",
				},
			}
			return colors
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
