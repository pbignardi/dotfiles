-- USER INTERFACE PLUGINS
-- file explorer, fuzzy finder, tabline, etc...

-- file explorer
require("mini.files").setup()

MiniDeps.later(function()
  local toggleFiles = function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end
  vim.keymap.set("n", "<leader>f", toggleFiles, { desc = "File explorer" })
end)

-- fuzzy finder
require("mini.extra").setup()
require("mini.pick").setup {
  window = {
    config = function()
      local width = math.floor(0.6 * vim.o.columns)
      local height = math.floor(0.6 * vim.o.lines)
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
require("snacks").setup {
  picker = { enabled = true },
}

MiniDeps.later(function()
  vim.keymap.set("n", "<leader>p", Snacks.picker.git_files, { desc = "Search project files" })
  vim.keymap.set("n", "<leader>/", Snacks.picker.buffers, { desc = "Search open buffers" })
  vim.keymap.set("n", "<leader>sh", Snacks.picker.help, { desc = "Search helptags" })
  vim.keymap.set("n", "<leader>sf", Snacks.picker.files, { desc = "Search files (all)" })
  vim.keymap.set("n", "<leader>sc", Snacks.picker.colorschemes, { desc = "Search colorschemes" })
  vim.keymap.set("n", "<leader>sg", Snacks.picker.grep, { desc = "Live grep" })
end)

-- statusline
require("mini.statusline").setup()

-- tabline
require("mini.tabline").setup {
  set_vim_settings = false,
}

-- diff
require("mini.diff").setup {
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
  },
}

-- git
require("mini.git").setup()

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniGitUpdated",
  callback = function(data)
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or ""
  end,
})

-- indentscope
require("mini.indentscope").setup {
  delay = 20,
  draw = {
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "▏",
}

-- notify
local opts = {
  content = {
    format = function(notif)
      local content = ""
      if notif.level == "INFO" then
        content = content .. "  Info - "
      elseif notif.level == "ERROR" then
        content = content .. "  Error - "
      elseif notif.level == "WARN" then
        content = content .. "  Warning - "
      elseif notif.level == "DEBUG" then
        content = content .. "  Debug - "
      else
        content = ""
      end
      return content .. notif.msg .. " "
    end,
  },
}

require("mini.notify").setup()

-- set colorscheme
vim.cmd.colorscheme "nordfox"
