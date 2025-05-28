return {
	{
		-- python venv selector
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		lazy = false,
		branch = "regexp",
		ft = { "python" },
		config = function()
			require("venv-selector").setup()
		end,
		keys = {
			{ "<leader>vs", vim.cmd.VenvSelect },
		},
	},
}
