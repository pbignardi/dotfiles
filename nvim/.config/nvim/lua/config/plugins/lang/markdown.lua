local filetype = { "markdown", "md" }
return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = filetype,
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			pipe_table = {
				style = "normal",
				border_virtual = true,
			},
			bullet = {
				left_pad = 1,
			},
			heading = {
				style = "block",
				width = "block",
				position = "inline",
				left_pad = 2,
				right_pad = 2,
				icons = { "󰎤  ", "󰎧  ", "󰎪  ", "󰎭  ", "󰎱  ", "󰎳  " },
			},
			code = {
				style = "full",
				width = "block",
				position = "right",
				right_pad = 2,
				min_width = 70,
				border = "thin",
			},
		},
	},
	{
		"toppair/peek.nvim",
		ft = filetype,
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}
