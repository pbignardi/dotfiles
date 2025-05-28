return {
	-- fzf lua
	{
		"ibhagwan/fzf-lua",
		enabled = true,
		opts = {},
		config = function(_, opts)
			local fzflua = require("fzf-lua")
			local actions = fzflua.actions

			fzflua.setup(opts)
			fzflua.register_ui_select()

			return ops
		end,
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
