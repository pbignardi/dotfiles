return {
    "stevearc/oil.nvim",
    enabled = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        columns = {
            "icon",
        },
        win_options = {
        },
        view_options = {
            show_hidden = false,
            is_hidden_file = function(name, bufnr)
                return vim.startswith(name, '.')
            end,
            is_always_hidden = function(name, bufnr)
                return false
            end
        },
        float = {
            padding = 5,
            max_width = 0.8,
            max_height = 0.7
        }
    },
    dependencies = {},
    config = true,
}
