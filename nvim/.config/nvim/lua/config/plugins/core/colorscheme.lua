local onedark = {
    "navarasu/onedark.nvim",
    config = function()
        require("onedark").setup({ style = "darker" })
    end,
}

local jellybeans = {
    'metalelf0/jellybeans-nvim',
    dependencies = {
        'rktjmp/lush.nvim'
    }
}

local tokyonight = {
    'folke/tokyonight.nvim'
}

return { jellybeans, tokyonight }
