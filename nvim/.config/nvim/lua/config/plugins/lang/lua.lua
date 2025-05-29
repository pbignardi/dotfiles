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
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0,
			})
		end,
	},
}
