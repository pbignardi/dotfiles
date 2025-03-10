require("config.options")
require("config.lazy")
require("config.remaps")
require("config.colorscheme")
require("config.filetypes")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
