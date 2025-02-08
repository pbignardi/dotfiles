local onedark = {
	"navarasu/onedark.nvim",
	config = function()
		require("onedark").setup({ style = "darker" })
		require("onedark").load()
	end,
}

local monokai = {
	"loctvl842/monokai-pro.nvim",
	config = function()
		require("monokai-pro").setup()
		vim.cmd.colorscheme("monokai-pro")
	end,
}

local hybrid = {
	"HoNamDuong/hybrid.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		vim.cmd.colorscheme("hybrid")
	end,
}

local vim_hybrid = {
	"w0ng/vim-hybrid",
	config = function()
		vim.cmd.colorscheme("hybrid")
	end,
}

return {}
