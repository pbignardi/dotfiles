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
MiniDeps.add { source = "NeogitOrg/neogit", depends = { "nvim-lua/plenary.nvim" } }
MiniDeps.add { source = "mfussenegger/nvim-dap" }
MiniDeps.add { source = "nvim-java/nvim-java", depends = { "MunifTanjim/nui.nvim" } }
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

MiniDeps.add { source = "bluz71/vim-moonfly-colors" }
-- common config
require "config.basics"
require "config.mappings"
require "config.options"
require "config.treesitter"

-- non-vscode config
if vim.g.vscode then
  return
end
require "config.ui"
require "config.fuzzy"
require "config.lspconfig"
require "config.completions"
require "config.formatters"
require "config.starter"
require "config.sessions"
require "config.vscode"
