local M = {}

M._term_col_names = {
  normal = {
    "terminal_color_0",
    "terminal_color_1",
    "terminal_color_2",
    "terminal_color_3",
    "terminal_color_4",
    "terminal_color_5",
    "terminal_color_6",
    "terminal_color_7",
  },
  bright = {
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

--- Fetch terminal colors from vim.g and Normal highlight group
local fetch = function()
  local cs = {
    foreground = nil,
    background = nil,
    normal = {},
    bright = {},
  }

  -- Get foreground and background from Normal highlight group
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  cs.foreground = string.format("#%06x", normal_hl.fg or 0xffffff)
  cs.background = string.format("#%06x", normal_hl.bg or 0x000000)

  for index, name in ipairs(M._term_col_names.normal) do
    cs.normal[index] = vim.g[name]
  end

  for index, name in ipairs(M._term_col_names.bright) do
    cs.bright[index] = vim.g[name]
  end
  return cs
end

--- Write content to file with optional overwrite protection
local write_file = function(content, target, overwrite)
  local expanded_path = vim.fs.normalize(vim.fn.expand(target))

  -- Check if file exists and overwrite is false
  local file = io.open(expanded_path, "w")
  if file then
    file:close()
    if not overwrite then
      error("File already exists at " .. expanded_path .. ". Use overwrite=true to replace.")
    end
  else
    error("Could not open file at " .. expanded_path)
  end

  -- Write file
  file = io.open(expanded_path, "w")
  if not file then
    error("Could not open file for writing: " .. expanded_path)
  end
  file:write(content)
  file:close()
end

--- Convert hex color to TOML format (keeps hex as-is)
local color_to_hex = function(color)
  if not color then
    return nil
  end
  return color:sub(1, 1) == "#" and color or "#" .. color
end

--- Generate TOML content for alacritty
local generate_alacritty = function(colors)
  local lines = {}
  table.insert(lines, "[colors.primary]")
  table.insert(lines, 'foreground = "' .. color_to_hex(colors.foreground) .. '"')
  table.insert(lines, 'background = "' .. color_to_hex(colors.background) .. '"')
  table.insert(lines, "")

  local color_names = {
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "magenta",
    "cyan",
    "white",
  }

  table.insert(lines, "[colors.normal]")
  for i, name in ipairs(color_names) do
    if colors.normal[i] then
      table.insert(lines, name .. ' = "' .. color_to_hex(colors.normal[i]) .. '"')
    end
  end
  table.insert(lines, "")

  table.insert(lines, "[colors.bright]")
  for i, name in ipairs(color_names) do
    if colors.bright[i] then
      table.insert(lines, name .. ' = "' .. color_to_hex(colors.bright[i]) .. '"')
    end
  end

  return table.concat(lines, "\n")
end

--- Generate Lua config for wezterm
local generate_wezterm = function(colors)
  local lines = {}
  table.insert(lines, "[colors]")
  local ansi_colors = ""
  local bright_colors = ""

  for index, color in ipairs(colors.normal) do
    ansi_colors = ansi_colors .. '"' .. color_to_hex(color) .. '"'
    if index < #colors.normal then
      ansi_colors = ansi_colors .. ","
    end
  end

  for index, color in ipairs(colors.bright) do
    bright_colors = bright_colors .. '"' .. color_to_hex(color) .. '"'
    if index < #colors.bright then
      bright_colors = bright_colors .. ","
    end
  end

  table.insert(lines, "ansi = [" .. ansi_colors .. "]")
  table.insert(lines, "brights = [" .. bright_colors .. "]")
  table.insert(lines, 'foreground = "' .. color_to_hex(colors.foreground) .. '"')
  table.insert(lines, 'background = "' .. color_to_hex(colors.background) .. '"')

  table.insert(lines, "")
  table.insert(lines, "[metadata]")
  table.insert(lines, 'aliases = ["nvim-generated"]')

  return table.concat(lines, "\n")
end

--- Generate config format for kitty
local generate_kitty = function(colors)
  local lines = {}

  for i = 0, 7 do
    if colors.normal[i + 1] then
      table.insert(lines, "color" .. i .. " " .. color_to_hex(colors.normal[i + 1]))
    end
  end

  for i = 8, 15 do
    if colors.bright[i - 7] then
      table.insert(lines, "color" .. i .. " " .. color_to_hex(colors.bright[i - 7]))
    end
  end

  table.insert(lines, "foreground " .. color_to_hex(colors.foreground))
  table.insert(lines, "background " .. color_to_hex(colors.background))

  return table.concat(lines, "\n")
end

-- Create theme file content for each terminal emulator
M._generators = {
  alacritty = generate_alacritty,
  wezterm = generate_wezterm,
  kitty = generate_kitty,
}

M._target_filename = {
  alacritty = "~/.config/alacritty/nvim-generated-colorscheme.toml",
  wezterm = "~/.config/wezterm/colors/nvim-generated-colorscheme.toml",
  kitty = "~/.config/kitty/nvim-generated-colorscheme.conf",
}

--- Export terminal colors to file for appropriate terminal emulator.
--- @param terminal string specify the format of the colorscheme to export ("alacritty", "wezterm", or "kitty")
--- @param overwrite boolean? whether to overwrite existing exported colorscheme (default: false)
--- @param target string? custom filename to export the colorscheme to
M.export = function(terminal, overwrite, target)
  local generator = M._generators[terminal]
  if not target then
    target = M._target_filename[terminal]
  end

  if not generator then
    error(
      "Required exporter for terminal '" .. terminal .. "' is not implemented. Supported: alacritty, wezterm, kitty"
    )
  end

  if not target then
    error("Undefined target filename for terminal " .. terminal)
  end

  -- Fetch and export colors
  local cs = fetch()
  local content = generator(cs)
  write_file(content, target, overwrite or false)
end

--- Create command to export colorscheme.
vim.api.nvim_create_user_command("ExportColors", function(input)
  local terminal = input.fargs[1]
  M.export(terminal, true)
  vim.notify("Exported " .. terminal .. " colorscheme")
end, { nargs = 1 })

return M
