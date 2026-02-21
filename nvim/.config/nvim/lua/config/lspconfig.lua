-- LSPCONFIG SETUP

-- setup mason asynchronously
require("mason").setup()

MiniDeps.later(function()
  require("mason-lspconfig").setup {
    ensure_installed = {
      "stylua",
      "lua_ls",
    },
  }
end)

-- configure keymaps
