local sonokai = {
	"sainnhe/sonokai",
	config = function()
		vim.cmd.colorscheme("sonokai")
	end,
}

local edge = {
	"sainnhe/edge",
	config = function()
		vim.cmd.colorscheme("edge")
	end,
}

local onedark = {
	"navarasu/onedark.nvim",
	config = function()
		require("onedark").setup({ style = "warmer" })
		require("onedark").load()
	end,
}

local rosepine = {
	"rose-pine/neovim",
	config = function()
		vim.cmd("colorscheme rose-pine")
	end,
}

local nordic = {
	"AlexvZyl/nordic.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nordic").setup({
			italic_comments = true,
			bright_border = true,
			reduced_blue = true,
			swap_background = false,
			cursorline = {
				bold_number = true,
				theme = "light",
			},
		})
		require("nordic").load()
	end,
}

return nordic
