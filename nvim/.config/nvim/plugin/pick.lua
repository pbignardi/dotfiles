-- mini.pick configuartion

if vim.g.vscode then
  return
end

Config.now(function()
  require("mini.pick").setup {
    mappings = {
      caret_left = "<M-b>",
      caret_right = "<M-f>",
    },
    window = {
      -- picker + always-visible preview (see lua/pick_preview.lua)
      config = require("pick_preview").win_config,
    },
  }
end)

-- configure vim.ui.select to use mini.pick
Config.later(function()
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {})
  end
end)
