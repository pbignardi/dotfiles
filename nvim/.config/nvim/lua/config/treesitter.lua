-- TREESITTER SETUP
-- Configure treesitter, textobjects and context

MiniDeps.now(require("nvim-treesitter").setup)
MiniDeps.now(require("treesitter-context").setup)
MiniDeps.now(function()
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

-- configure tree-sitter main plugin
local ensure_installed = {
  "cpp",
  "c",
  "python",
  "lua",
  "bash",
  "matlab",
  "java",
}
local already_installed = require("nvim-treesitter").get_installed()
local parser_to_install = {}

for _, parser in ipairs(ensure_installed) do
  if not vim.tbl_contains(already_installed, parser) then
    table.insert(parser_to_install, parser)
  end
end
require("nvim-treesitter").install(parser_to_install)

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

MiniDeps.later(function()
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
