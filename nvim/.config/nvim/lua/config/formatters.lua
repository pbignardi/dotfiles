require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
  },
  format_on_save = true,
}
