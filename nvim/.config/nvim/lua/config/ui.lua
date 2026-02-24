-- USER INTERFACE PLUGINS
-- file explorer, fuzzy finder, tabline, etc...

-- file explorer
MiniDeps.now(require("mini.files").setup)

MiniDeps.later(function()
  local toggleFiles = function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end
  vim.keymap.set("n", "<leader>f", toggleFiles, { desc = "File explorer" })
end)

-- fuzzy finder
MiniDeps.now(require("mini.extra").setup)
MiniDeps.now(function()
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
end)

local workspace_diagnostics = function()
  MiniExtra.pickers.diagnostic { scope = "all" }
end

MiniDeps.later(function()
  vim.keymap.set("n", "<leader>p", MiniExtra.pickers.git_files, { desc = "Search project files" })
  vim.keymap.set("n", "<leader>/", MiniPick.builtin.buffers, { desc = "Search open buffers" })
  vim.keymap.set("n", "<leader>sh", MiniPick.builtin.help, { desc = "Search helptags" })
  vim.keymap.set("n", "<leader>sf", MiniPick.builtin.files, { desc = "Search files (all)" })
  vim.keymap.set("n", "<leader>sc", MiniExtra.pickers.colorschemes, { desc = "Search colorschemes" })
  vim.keymap.set("n", "<leader>sg", MiniPick.builtin.grep_live, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>sd", MiniExtra.pickers.git_hunks, { desc = "Search git hunks" })
  vim.keymap.set("n", "<leader>df", MiniExtra.pickers.diagnostic, { desc = "File diagnostics" })
  vim.keymap.set("n", "<leader>dw", workspace_diagnostics, { desc = "Workspace diagnostics" })
end)

-- statusline
local statusline = require "mini.statusline"
local active_statusbar = function()
  local mode, mode_hl = statusline.section_mode {}
  local git = statusline.section_git {}
  local diff = statusline.section_diff {}
  if not string.find(diff, "%d") then
    diff = ""
  end
  local diagnostics = statusline.section_diagnostics {}
  local lsp = statusline.section_lsp {}
  local filename = "󰈙 " .. vim.fn.expand "%:t"
  local location = statusline.section_location { trunc_width = 1000 }
  return statusline.combine_groups {
    { hl = mode_hl, strings = { string.upper(mode) } },
    { hl = "MiniStatuslineFilename", strings = { filename } },
    { hl = "MiniStatuslineDevInfo", strings = { git } },
    { hl = "MiniStatuslineInactive", strings = { diff } },
    "%<",
    { hl = "MiniStatuslineInactive", strings = {} },
    "%=",
    { hl = "MiniStatuslineInactive", strings = { diagnostics, lsp } },
    { hl = "MiniStatuslineDevInfo", strings = { location } },
  }
end

MiniDeps.now(function()
  require("mini.statusline").setup {
    content = {
      active = active_statusbar,
    },
  }
end)

-- tabline
MiniDeps.later(function()
  require("mini.tabline").setup {
    set_vim_settings = false,
  }
end)

-- diff
MiniDeps.later(function()
  require("mini.diff").setup {
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  }
end)

-- git
MiniDeps.later(function()
  require("mini.git").setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitUpdated",
    callback = function(data)
      local summary = vim.b[data.buf].minigit_summary
      vim.b[data.buf].minigit_summary_string = summary.head_name or ""
    end,
  })
end)

-- indentscope
MiniDeps.later(function()
  require("mini.indentscope").setup {
    delay = 20,
    draw = {
      animation = require("mini.indentscope").gen_animation.none(),
    },
    symbol = "▏",
  }
end)

-- notify
MiniDeps.later(function()
  require("mini.notify").setup {
    content = {
      format = function(notif)
        local content_level = {
          INFO = "  Info - ",
          ERROR = "  Error - ",
          WARN = "  Warning - ",
          DEBUG = "  Debug - ",
        }
        local content = content_level[notif.level] or ""
        return content .. notif.msg .. " "
      end,
    },
    window = {
      config = {
        border = "rounded",
      },
      max_width_share = 0.4,
    },
  }
end)

-- set colorscheme
MiniDeps.now(function()
  require("onedark").setup {
    style = "warmer",
  }
  vim.cmd.colorscheme "onedark"
end)
