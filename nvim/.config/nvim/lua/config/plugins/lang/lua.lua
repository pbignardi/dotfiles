return {
	{
		"folke/lazydev.nvim",
		ft = { "lua" },
		config = function()
			require("lazydev.nvim").setup({
				library = { "nvim-dap-ui" },
			})
		end,
	},
}
