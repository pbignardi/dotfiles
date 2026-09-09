-- treesitter setup
-- Configure treesitter, textobjects and context

-- setup treesitter update before plugin installation
vim.api.nvim_create_autocmd("PackChanged", { callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
        if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
        vim.cmd("TSUpdate")
    end
end})

-- install treesitter and plugins
vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter-context"
})

Config.now(require("nvim-treesitter").setup)
Config.now(require("treesitter-context").setup)
Config.now(function()
  require("nvim-treesitter-textobjects").setup {
    move = {
      set_jumps = true,
    },
    select = {
      lookahead = true,
    },
  }
  vim.g.no_plugin_maps = true
end)

local ignored_langs = {
  "latex",
}

-- configure tree-sitter autoinstall parsers
Config.now(function()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local lang = vim.treesitter.language.get_lang(ev.match)
      local is_ignored = vim.tbl_contains(ignored_langs, lang)
      if is_ignored then
        return
      end

      local available_langs = require("nvim-treesitter").get_available()
      local is_available = vim.tbl_contains(available_langs, lang)

      if is_available then
        local installed_langs = require("nvim-treesitter").get_installed()
        local installed = vim.tbl_contains(installed_langs, lang)
        if not installed then
          require("nvim-treesitter").install(lang):wait()
        end
        vim.treesitter.start()
        require("nvim-treesitter").indentexpr()
      end
    end,
  })
end)

-- TODO: move into mappings.lua
-- define and configure textobjects
local textobject_move = {
  -- function
  { lhs = "]f", method = "goto_next_start", tag = "@function.outer" },
  { lhs = "[f", method = "goto_previous_start", tag = "@function.outer" },
  { lhs = "]F", method = "goto_next_end", tag = "@function.outer" },
  { lhs = "[F", method = "goto_previous_end", tag = "@function.outer" },
  -- class
  { lhs = "]c", method = "goto_next_start", tag = "@class.outer" },
  { lhs = "[c", method = "goto_previous_start", tag = "@class.outer" },
  { lhs = "]C", method = "goto_next_end", tag = "@class.outer" },
  { lhs = "[C", method = "goto_previous_end", tag = "@class.outer" },
  -- function parameters
  { lhs = "]v", method = "goto_next_start", tag = "@parameter.outer" },
  { lhs = "[v", method = "goto_previous_start", tag = "@parameter.outer" },
  -- loop
  { lhs = "]l", method = "goto_next_start", tag = { "@loop.inner", "@loop.outer" } },
  { lhs = "[l", method = "goto_previous_start", tag = { "@loop.inner", "@loop.outer" } },
}

local textobject_select = {
  { lhs = "af", method = "select_textobject", tag = "@function.outer" },
  { lhs = "if", method = "select_textobject", tag = "@function.inner" },
  { lhs = "av", method = "select_textobject", tag = "@parameter.outer" },
  { lhs = "iv", method = "select_textobject", tag = "@parameter.inner" },
  { lhs = "al", method = "select_textobject", tag = "@loop.outer" },
  { lhs = "il", method = "select_textobject", tag = "@loop.inner" },
  { lhs = "ial", method = "select_textobject", tag = "@assignment.lhs" },
  { lhs = "iar", method = "select_textobject", tag = "@assignment.rhs" },
}

Config.later(function()
  -- set textobjects move keymaps
  local tsmove = require "nvim-treesitter-textobjects.move"
  for _, map in ipairs(textobject_move) do
    vim.keymap.set({ "n", "x", "o" }, map.lhs, function()
      tsmove[map.method](map.tag, "textobjects")
    end)
  end

  -- set textobjects move keymaps
  local tsselect = require "nvim-treesitter-textobjects.select"
  for _, map in ipairs(textobject_select) do
    vim.keymap.set({ "x", "o" }, map.lhs, function()
      tsselect[map.method](map.tag, "textobjects")
    end)
  end
end)
