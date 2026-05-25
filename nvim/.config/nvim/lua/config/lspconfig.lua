-- LSPCONFIG SETUP
local map = vim.keymap.set

-- setup mason asynchronously
MiniDeps.now(function()
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

MiniDeps.later(function()
  require("mason-lspconfig").setup {
    automatic_enable = true,
  }
end)

-- custom lsp keymaps
MiniDeps.later(function()
  map("n", "K", vim.lsp.buf.hover, { desc = "hover" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "signature help" })
  map("n", "<leader>gc", vim.lsp.buf.code_action, { desc = "code action" })
  map("n", "<leader>gn", vim.lsp.buf.rename, { desc = "rename" })
end)
