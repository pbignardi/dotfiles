return {
	-- fzf lua
	{
		"ibhagwan/fzf-lua",
		enabled = true,
		opts = {},
	},
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Telescope UI Select
	{
		"nvim-telescope/telescope-ui-select.nvim",
		enabled = false,
		opts = {},
		config = function()
			require("telescope").setup({
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
