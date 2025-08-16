local wezterm = require("wezterm")
local M = {}

local generators = {}

-- functions
local function darken_black(color_scheme)
	color_scheme.brights[1] = color_scheme.ansi[1]
	color_scheme.ansi[1] = color_scheme.background
	return color_scheme
end

-- moonfly
local function chalk()
	local cs = wezterm.color.get_builtin_schemes()["Chalk (base16)"]
	return cs
end
generators.chalk = chalk

-- moonfly
local function moonfly()
	local cs = wezterm.color.get_builtin_schemes()["Moonfly (Gogh)"]
	cs = darken_black(cs)
	return cs
end
generators.moonfly = moonfly

-- xcode
local function xcodehc()
	local cs = wezterm.color.get_builtin_schemes()["XCode Dusk"]
	return cs
end
generators.xcodehc = xcodehc

-- onedark
local function onedark()
	local cs = wezterm.color.get_builtin_schemes()["OneDark (base16)"]
	return cs
end
generators.onedark = onedark

-- gruvbox material
local function gruvbox_material()
	local cs = wezterm.color.get_builtin_schemes()["Gruvbox Material (base16)"]
	return cs
end
generators.gruvbox_material = gruvbox_material

-- srcery
local function srcery()
	local cs = wezterm.color.get_builtin_schemes()["Srcery (Gogh)"]
	return cs
end
generators.srcery = srcery

-- sonokai
local function sonokai()
	local cs = wezterm.color.get_builtin_schemes()["Sonokai (Gogh)"]
	return cs
end
generators.sonokai = sonokai

-- monokai
local function monokai()
	local cs = wezterm.color.get_builtin_schemes()["Monokai (terminal.sexy)"]
	cs = darken_black(cs)
	return cs
end
generators.monokai = monokai

local color_scheme_names = {
	moonfly = "Moonfly",
	xcodehc = "XcodeHC",
	onedark = "Onedark",
	gruvbox_material = "Gruvbox Material",
	srcery = "Srcery",
	sonokai = "Sonokai",
	monokai = "Monokai",
	chalk = "Chalk",
}

-- TODO
-- dasupradyumna/midnight.nvim,
-- "scottmckendry/cyberdream.nvim",

function M.init(color_scheme)
	for index, value in pairs(color_scheme_names) do
		if value == color_scheme then
			return { [value] = generators[index]() }
		end
	end
end

return M
