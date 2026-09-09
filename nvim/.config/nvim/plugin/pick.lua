-- mini.pick configuartion

Config.now(function()
  require("mini.pick").setup {
    mappings = {
      caret_left = "<M-b>",
      caret_right = "<M-f>",
    },
    window = {
      config = function()
        local width = math.floor(0.8 * vim.o.columns)
        local height = math.floor(0.5 * vim.o.lines)
        return {
          anchor = "NW",
          height = height,
          width = width,
          row = math.floor(0.5 * (vim.o.lines - height)),
          col = math.floor(0.5 * (vim.o.columns - width)),
        }
      end,
    },
  }
end)

-- configure vim.ui.select to use mini.pick
Config.later(function()
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {})
  end
end)
