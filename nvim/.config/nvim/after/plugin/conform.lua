-- conform.nvim configuration

if vim.g.vscode then
  return
end

Config.later(function()
  require("conform").setup {
    format_on_save = {
      timeout_ms = 300,
      lsp_format = "fallback",
    },
  }
end)
