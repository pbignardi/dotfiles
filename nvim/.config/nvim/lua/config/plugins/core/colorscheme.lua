local onedark = {
    "navarasu/onedark.nvim",
    config = function()
        require("onedark").setup({ style = "warmer" })
    end,
}

local jellybeans = {
    'metalelf0/jellybeans-nvim',
    dependencies = {
        'rktjmp/lush.nvim'
    }
}

local nightfox = {
    "EdenEast/nightfox.nvim"
}

local kanagawa = {
    "rebelot/kanagawa.nvim"
}

local melange = {
    "savq/melange-nvim"
}

local dracula = {
    "Mofiqul/dracula.nvim"
}


return { nightfox, onedark, jellybeans, kanagawa, melange, dracula }
