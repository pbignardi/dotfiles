-- USER INTERFACE PLUGINS
-- file explorer, tabline, etc...

-- file explorer
MiniDeps.now(require("mini.files").setup)

MiniDeps.later(function()
  local toggleFiles = function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end
  vim.keymap.set("n", "<leader>e", toggleFiles, { desc = "file explorer" })
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

  local diagnostics = statusline.section_diagnostics {
    signs = { ERROR = " ", WARN = " ", INFO = " ", HINT = " " },
    icon = "",
  }
  local lsp = statusline.section_lsp { icon = " LSP" }
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
    { hl = "MiniStatuslineInactive", strings = { diagnostics } },
    "%<",
    { hl = "MiniStatuslineInactive", strings = { lsp } },
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
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_keymaps = {
  { "n", "gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log" },
  { "n", "go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay" },
  { "x", "gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection" },
}

MiniDeps.later(function()
  require("mini.git").setup()
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniGitUpdated",
    callback = function(data)
      local summary = vim.b[data.buf].minigit_summary
      vim.b[data.buf].minigit_summary_string = summary.head_name or ""
    end,
  })

  for _, kmap in ipairs(git_keymaps) do
    vim.keymap.set(kmap[1], kmap[2], kmap[3], { desc = kmap[4] })
  end
end)

-- indentscope
MiniDeps.later(function()
  require("mini.indentscope").setup {
    delay = 0,
    draw = {
      animation = require("mini.indentscope").gen_animation.none(),
    },
    symbol = "▏",
  }
end)

-- notify
local content_level = { INFO = "", ERROR = "󰅙", WARN = "", DEBUG = "" }
local winconfig = function()
  return {
    border = "none",
    anchor = "SE",
    col = vim.o.columns,
    row = vim.o.lines - 2,
    title = "",
  }
end

local notif_format = function(notif)
  local icon = content_level[notif.level] or ""
  local msg = notif.msg
  return icon .. " " .. msg
end

MiniDeps.later(function()
  require("mini.notify").setup {
    content = {
      format = notif_format,
    },
    window = {
      config = winconfig,
      max_width_share = 0.4,
    },
  }
  vim.notify = MiniNotify.make_notify {
    ERROR = { duration = 5000, hl_group = "DiagnosticError" },
    WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
    INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
    DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
    TRACE = { duration = 0, hl_group = "DiagnosticOk" },
    OFF = { duration = 0, hl_group = "DiagnosticInfo" },
  }
end)

-- key hinting
local miniclue = require "mini.clue"
MiniDeps.later(function()
  miniclue.setup {
    window = {
      config = { anchor = "NE", col = "auto", row = "auto" },
    },
    triggers = {
      -- Leader triggers
      { mode = { "n", "x" }, keys = "<Leader>" },

      -- `[` and `]` keys
      { mode = "n", keys = "[" },
      { mode = "n", keys = "]" },

      -- `g` key
      { mode = { "n", "x" }, keys = "g" },

      -- Marks
      { mode = { "n", "x" }, keys = "'" },
      { mode = { "n", "x" }, keys = "`" },

      -- Registers
      { mode = { "n", "x" }, keys = '"' },
      { mode = { "i", "c" }, keys = "<C-r>" },

      -- Window commands
      { mode = "n", keys = "<C-w>" },

      -- `z` key
      { mode = { "n", "x" }, keys = "z" },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      -- miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<leader>g", desc = "+lsp" },
      { mode = "n", keys = "<leader>d", desc = "+diagnostic" },
      { mode = "n", keys = "<leader>f", desc = "+fuzzyfind" },
      { mode = "n", keys = "<leader>s", desc = "+sessions" },
      { mode = "n", keys = "<leader>t", desc = "+trailspace" },
    },
  }
end)

-- set colorscheme
MiniDeps.now(function()
  vim.cmd.colorscheme "miniautumn"
end)
