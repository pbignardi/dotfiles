-- Mini.nvim plugins

-- mini.basics
Config.now(require("mini.basics").setup)

-- mini.ai
Config.later(require("mini.ai").setup)

-- mini.surround
Config.later(require("mini.surround").setup)

-- mini.pairs
Config.later(require("mini.pairs").setup)

-- mini.icons
Config.now(require("mini.icons").setup)

-- mini.comment
Config.later(require("mini.comment").setup)

-- mini.trailspace
Config.later(require("mini.trailspace").setup)

-- mini.git
Config.now(require("mini.git").setup)

-- mini.extra
Config.later(require("mini.extra").setup)

-- file explorer
Config.now(require("mini.files").setup)

-- statusline
Config.now(require("mini.statusline").setup)

-- tabline
Config.later(function()
  require("mini.tabline").setup {
    set_vim_settings = false,
  }
end)

-- diff
Config.later(function()
  require("mini.diff").setup {
    view = {
      style = "sign",
      signs = { add = "+", change = "~", delete = "-" },
    },
  }
end)

-- git
Config.later(require("mini.git").setup)

-- indentscope
Config.now(function()
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

Config.later(function()
  local notify = require "mini.notify"
  notify.setup {
    content = {
      format = function(notif)
        local icon = content_level[notif.level] or ""
        local msg = notif.msg
        return icon .. " " .. msg
      end,
    },
    window = {
      config = function()
        return {
          border = "none",
          anchor = "SE",
          col = vim.o.columns,
          row = vim.o.lines - 2,
          title = "",
        }
      end,
      max_width_share = 0.4,
    },
  }
  vim.notify = notify.make_notify {
    ERROR = { duration = 5000, hl_group = "DiagnosticError" },
    WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
    INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
    DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
    TRACE = { duration = 0, hl_group = "DiagnosticOk" },
    OFF = { duration = 0, hl_group = "DiagnosticInfo" },
  }
end)

-- key hinting
Config.later(function()
  local clue = require "mini.clue"
  clue.setup {
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
      clue.gen_clues.square_brackets(),
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      -- miniclue.gen_clues.windows(),
      clue.gen_clues.z(),
      { mode = "n", keys = "<leader>g", desc = "+lsp" },
      { mode = "n", keys = "<leader>d", desc = "+diagnostic" },
      { mode = "n", keys = "<leader>f", desc = "+fuzzyfind" },
      { mode = "n", keys = "<leader>s", desc = "+sessions" },
      { mode = "n", keys = "<leader>t", desc = "+trailspace" },
      { mode = "n", keys = "<leader>q", desc = "+neogit" },
    },
  }
end)

-- mini git after config

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_keymaps = {
  { "n", "gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log" },
  { "n", "go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay" },
  { "x", "gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at selection" },
}
local minigit_after = function()
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
end

-- mini files after config

Config.later(function()
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
