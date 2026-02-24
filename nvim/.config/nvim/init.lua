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

-- enable mini.deps
require("mini.deps").setup { path = { package = path_package } }

-- install external plugins
MiniDeps.add { source = "projekt0n/github-nvim-theme" }
MiniDeps.add { source = "navarasu/onedark.nvim" }
MiniDeps.add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd "TSUpdate"
    end,
  },
}
MiniDeps.add { source = "nvim-treesitter/nvim-treesitter-textobjects" }
MiniDeps.add { source = "nvim-treesitter/nvim-treesitter-context" }
MiniDeps.add { source = "mason-org/mason.nvim" }
MiniDeps.add { source = "mason-org/mason-lspconfig.nvim" }
MiniDeps.add { source = "neovim/nvim-lspconfig" }
MiniDeps.add { source = "stevearc/conform.nvim" }
MiniDeps.add { source = "Saghen/blink.cmp", checkout = "v1.9.1" }

-- REQUIRE CONFIGS
local require_now = function(module)
  MiniDeps.now(function()
    require(module)
  end)
end

require_now "config.basics"
require_now "config.mappings"
require_now "config.options"
require_now "config.treesitter"
require_now "config.ui"
require_now "config.lspconfig"
require_now "config.completions"
require_now "config.formatters"
require_now "config.starter"

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
