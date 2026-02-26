-- setup conform
MiniDeps.later(function()
  require("conform").setup {
    formatters_by_ft = _G.formatter_by_ft,
    format_on_save = {
      lsp_format = "fallback",
    },
  }
end)
