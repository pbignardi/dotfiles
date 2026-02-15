-- setup mini.deps
local path_package = vim.fn.stdpath "data" .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/nvim-mini/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd "packadd mini.nvim | helptags ALL"
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup { path = { package = path_package } }

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup(
    "kickstart-highlight-yank",
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local nmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

-- import configs
require "config.mappings"
require "config.options"

-- BASIC
require("mini.basics").setup()
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.comment").setup()
require("mini.trailspace").setup()

vim.keymap.set(
  "n",
  "<leader>ts",
  require("mini.trailspace").trim,
  { desc = "Trim trailing spaces" }
)

-- TREESITTER
MiniDeps.add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd "TSUpdate"
    end,
  },
}
require("nvim-treesitter").setup()

local ensure_installed = {
  "cpp",
  "c",
  "python",
  "lua",
  "bash",
}
local already_installed = require("nvim-treesitter").get_installed()
local parser_to_install = {}

for _, parser in ipairs(ensure_installed) do
  if not vim.tbl_contains(already_installed, parser) then
    table.insert(parser_to_install, parser)
  end
end
require("nvim-treesitter").install(parser_to_install)

-- install textobjects
MiniDeps.add {
  source = "nvim-treesitter/nvim-treesitter-textobjects",
}

vim.g.no_plugin_maps = true
require("nvim-treesitter-textobjects").setup()

local tsmove = require "nvim-treesitter-textobjects.move"
vim.keymap.set({ "n", "x", "o" }, "]f", function()
  tsmove.goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]c", function()
  tsmove.goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]l", function()
  tsmove.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]F", function()
  tsmove.goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]C", function()
  tsmove.goto_next_end("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[f", function()
  tsmove.goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
  tsmove.goto_previous_start("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[F", function()
  tsmove.goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[C", function()
  tsmove.goto_previous_end("@class.outer", "textobjects")
end)

-- setup treesitter context
MiniDeps.add {
  source = "nvim-treesitter/nvim-treesitter-context",
}
require("treesitter-context").setup()

-- setup lspconfig and mason
MiniDeps.add {
  source = "neovim/nvim-lspconfig",
  depends = { "mason-org/mason.nvim" },
}
require("mason").setup()

vim.lsp.enable "lua_ls"

-- set custom lsp keymaps
-- local lsp_keymaps = {
--     { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
--     { "gr", lsp_view('references'), desc = "References", has = "references"},
--     { "gI", lsp_view('implementations'), desc = "Goto Implementation", has = "implementation"},
--     { "gy", lsp_view('type_definitions'), desc = "Goto T[y]pe Definition", has = "typeDefinition" },
--     { "gD", lsp_view('declarations'), desc = "Goto Declaration", has = "declaration"},
--     { "K", function() return vim.lsp.buf.hover() end, desc = "Hover", has = "hover"},
--     { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
--     { "<leader>ca", lsp_diagnostic, desc = "Code Action", has = "codeAction" },
--     { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
-- }

-- UI CONFIGURATION
-- set colorscheme
MiniDeps.add "vague-theme/vague.nvim"
require("vague").setup()
vim.cmd.colorscheme "vague"

-- files
require("mini.files").setup()
local toggle_files = function()
  if not MiniFiles.close() then
    MiniFiles.open()
  end
end
nmap("<leader>e", toggle_files, "Toggle file explorer")

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

local find_files = function()
  require("mini.pick").builtin.files { tool = "fd" }
end

local find_gitfiles = function()
  require("mini.pick").builtin.files { tool = "git" }
end

nmap("<leader>fh", MiniPick.builtin.help, "Search helptags")
nmap("<leader>/", MiniPick.builtin.buffers, "Search open buffers")
nmap("<leader>ff", find_files, "Search files (all)")
nmap("<leader>fc", MiniExtra.pickers.colorschemes, "Search colorschemes")
nmap("<leader>p", find_gitfiles, "Search project files")

-- setup conform
MiniDeps.add { source = "stevearc/conform.nvim" }
require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format { bufnr = args.buf, async = true }
  end,
})
