-- USER INTERFACE PLUGINS
-- file explorer, tabline, etc...

-- file explorer
MiniDeps.now(require("mini.files").setup)

MiniDeps.later(function()
  local toggleFiles = function()
    return not MiniFiles.close() and MiniFiles.open()
  end
  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. " split")
        return vim.api.nvim_get_current_win()
      end)
      MiniFiles.set_target_window(new_target)
      MiniFiles.go_in()
    end
    local desc = "Split " .. direction
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      map_split(buf_id, "<C-s>", "belowright vertical")
      map_split(buf_id, "<C-h>", "belowright horizontal")
      map_split(buf_id, "<C-t>", "tab")
    end,
  })

  vim.keymap.set("n", "<leader>e", toggleFiles, { desc = "file explorer" })
end)

-- statusline
MiniDeps.now(function()
  require("lualine").setup {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = nil, right = nil },
      section_separators = { left = nil, right = nil },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename", "diff" },
      lualine_x = { "encoding", "diagnostics", "lsp_status" },
      lualine_y = { "filetype" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = { "filename" },
      lualine_x = { "location" },
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

-- neogit
MiniDeps.later(function()
  vim.keymap.set("n", "<leader>qq", "<Cmd>Neogit<CR>", { desc = "status" })
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
      { mode = "n", keys = "<leader>q", desc = "+neogit" },
    },
  }
end)

-- set colorscheme
MiniDeps.now(function()
  require("onedark").setup { style = "darker" }
  vim.cmd.colorscheme "onedark"
end)
