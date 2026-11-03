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

if vim.g.vscode then
  return
end

-- mini.extra
Config.later(require("mini.extra").setup)

-- file explorer
Config.now(require("mini.files").setup)

-- statusline
Config.now(require("mini.statusline").setup)

-- statusline
Config.now(function()
  local statuscolumn = require "mini.statuscolumn"
  statuscolumn.setup {
    content = statuscolumn.gen_content.main {
      -- { pos = "cursor", sep = "▍" },
      { format = "lf=s", sep = "▍" },
    },
  }
end)

-- bufremove
Config.now(require("mini.bufremove").setup)

-- tabline
Config.later(function()
  require("mini.tabline").setup {
    set_vim_settings = false,
  }
end)

Config.later(function()
  local hipatterns = require "mini.hipatterns"
  hipatterns.setup {
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
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
