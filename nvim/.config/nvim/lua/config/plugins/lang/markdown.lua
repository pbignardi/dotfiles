local filetype = { "markdown", "md" }
return {
	{
		enabled = false,
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"wallpants/github-preview.nvim",
		cmd = { "GithubPreviewToggle" },
		keys = { "<leader>mpt" },
		opts = {
			port = 1234,
			log_level = "verbose",
		},
		config = function(_, opts)
			local gpreview = require("github-preview")
			gpreview.setup(opts)

			local fns = gpreview.fns
			vim.keymap.set("n", "<leader>mpt", fns.toggle)
			vim.keymap.set("n", "<leader>mps", fns.single_file_toggle)
			vim.keymap.set("n", "<leader>mpd", fns.details_tags_toggle)
		end,
	},
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
}
