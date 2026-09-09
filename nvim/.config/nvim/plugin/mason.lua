-- install mason and mason-lspconfig
vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim"
})

Config.now(function()
    require("mason").setup {
    ui = {
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
      width = 0.65,
    },
  }
end)

Config.now(function()
  require("mason-lspconfig").setup {
    automatic_enable = true,
  }
end)
