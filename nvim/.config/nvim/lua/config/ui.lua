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
  vim.keymap.set("n", "<leader>e", toggleFiles, { desc = "File explorer" })
end)

-- fuzzy finder
MiniDeps.now(require("mini.extra").setup)
MiniDeps.now(function()
  require("mini.pick").setup {
    mappings = {
      caret_left = "<M-b>",
      caret_right = "<M-f>",
    },
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

MiniDeps.later(function()
  vim.ui.select = function(items, opts, on_choice)
    return MiniPick.ui_select(items, opts, on_choice, {})
  end
end)

local file_diagnostic = function()
  MiniExtra.pickers.diagnostic { scope = "current" }
end

MiniDeps.later(function()
  -- add picker to search through pickers
  MiniPick.registry.pickers = function()
    local items = vim.tbl_keys(MiniPick.registry)
    table.sort(items)
    local source = { items = items, name = "Pickers", choose = function() end }
    local chosen_picker_name = MiniPick.start { source = source }
    if chosen_picker_name == nil then
      return
    end
    return MiniPick.registry[chosen_picker_name]()
  end
end)

MiniDeps.later(function()
  vim.keymap.set("n", "<leader>p", MiniExtra.pickers.git_files, { desc = "Find project files" })
  vim.keymap.set("n", "<leader>/", MiniPick.builtin.buffers, { desc = "Find open buffers" })
  vim.keymap.set("n", "<leader>fh", MiniPick.builtin.help, { desc = "Find helptags" })
  vim.keymap.set("n", "<leader>ff", MiniPick.builtin.files, { desc = "Find files (all)" })
  vim.keymap.set("n", "<leader>fc", MiniExtra.pickers.colorschemes, { desc = "Find colorschemes" })
  vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep_live, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fd", MiniExtra.pickers.git_hunks, { desc = "Find git hunks" })
  vim.keymap.set("n", "<leader>df", file_diagnostic, { desc = "File diagnostics" })
  vim.keymap.set("n", "<leader>dw", MiniExtra.pickers.diagnostic, { desc = "Workspace diagnostics" })
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
    delay = 20,
    draw = {
      animation = require("mini.indentscope").gen_animation.none(),
    },
    symbol = "▏",
  }
end)

-- notify
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
  local content_level = { INFO = "", ERROR = "󰅙", WARN = "", DEBUG = "" }
  local icon = content_level[notif.level] or ""
  return icon .. " " .. notif.msg .. " "
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
end)

-- set colorscheme
MiniDeps.now(function()
  require("onedark").setup {
    style = "warmer",
  }
  vim.cmd.colorscheme "onedark"
end)
