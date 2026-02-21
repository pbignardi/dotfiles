-- LSPCONFIG SETUP

-- setup mason asynchronously
require("mason").setup()

MiniDeps.later(function()
  require("mason-lspconfig").setup {
    ensure_installed = {
      "stylua",
      "emmylua_ls",
    },
  }
end)

-- configure keymaps
