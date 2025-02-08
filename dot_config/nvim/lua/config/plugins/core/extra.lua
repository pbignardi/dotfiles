return {
	-- python venv selector
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
		lazy = false,
		branch = "regexp",
		config = function()
			require("venv-selector").setup()
		end,
		keys = {
			{ "<leader>vs", vim.cmd.VenvSelect },
		},
	},
	-- fzf lua
	{
		"ibhagwan/fzf-lua",
		opts = {},
	},
	-- show colors
	{
		"norcalli/nvim-colorizer.lua",
		enabled = true,
		config = function()
			require("colorizer").setup()
		end,
	},
	-- Display keychords
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
