-- setup formatters
local formatters_by_filetype = {
  lua = { "stylua" },
  python = { "ruff" },
}
-- TODO: install missing formatters
-- setup conform
MiniDeps.later(function()
  require("conform").setup {
    formatters_by_ft = formatters_by_filetype,
    format_on_save = {
      lsp_format = "fallback",
    },
  }
end)
