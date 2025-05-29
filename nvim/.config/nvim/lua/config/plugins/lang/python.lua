local filetype = "python"
return {
	{
		-- python venv selector
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		branch = "regexp",
		ft = filetype,
		opts = {
			options = {
				picker = "fzf-lua",
			},
		},
		keys = {
			{ "<leader>vs", vim.cmd.VenvSelect, desc = "Select Python virtual environment", ft = filetype },
		},
	},
	{
		-- python debug adapter protocol
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("uv")
		end,
	},
}
