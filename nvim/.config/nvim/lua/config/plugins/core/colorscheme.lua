local onedark = {
    "navarasu/onedark.nvim",
    config = function()
        require("onedark").setup({ style = "darker" })
        -- require("onedark").load()
    end,
}

local monokai = {
    "loctvl842/monokai-pro.nvim",
    config = function()
        require("monokai-pro").setup()
        -- vim.cmd.colorscheme("monokai-pro")
    end,
}

local jellybeans = {
    'metalelf0/jellybeans-nvim',
    dependencies = {
        'rktjmp/lush.nvim'
    }
}

return { jellybeans, monokai }
