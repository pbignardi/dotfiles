local filetype = { "lua" }
return {
	{
		"folke/lazydev.nvim",
		ft = filetype,
		opts = {
			library = {
				"nvim-dap-ui",
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
