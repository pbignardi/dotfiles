-- install nvim-lspconfig

if vim.g.vscode then
  return
end

vim.pack.add {
  { src = "https://github.com/neovim/nvim-lspconfig" },
}
