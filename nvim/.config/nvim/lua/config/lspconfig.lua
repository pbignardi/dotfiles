-- LSPCONFIG SETUP

-- setup mason asynchronously
MiniDeps.now(function()
  require("mason").setup {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
      width = 0.65,
    },
  }
end)

MiniDeps.later(function()
  require("mason-lspconfig").setup {
    ensure_installed = {
      "stylua",
      "lua_ls",
    },
  }
end)

-- configure keymaps TODO
