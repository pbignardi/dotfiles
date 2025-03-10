return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = false,
            is_hidden_file = function(name, bufnr)
                return vim.startswith(name, '.')
            end,
            is_always_hidden = function(name, bufnr)
                return false
            end
        }
    },
    dependencies = {},
    config = true,
}
