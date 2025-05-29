return {
	{
		"echasnovski/mini.clue",
		enabled = false,
		version = false,
		config = function()
			local miniclue = require("mini.clue")
			miniclue.setup({})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
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
