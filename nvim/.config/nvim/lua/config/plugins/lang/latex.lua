local filetype = { "tex", "latex" }
return {
	"lervag/vimtex",
	ft = filetype,
	config = function()
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_view_skim_activate = 1
		vim.g.vimtex_view_skim_no_select = 1
		vim.g.vimtex_view_skim_reading_bar = 1
		vim.g.vimtex_view_skim_sync = 1
		vim.g.vimtex_quickfix_open_on_warning = 0
		vim.g.vimtex_compiler_latexmk = {
			options = {
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"--shell-escape",
			},
		}
	end,
	keys = {
		{ "<leader>lf", vim.cmd.ccl and vim.cmd.VimtexCompileSS, desc = "Vimtex: Compile", ft = filetype },
	},
}
