local filetype = { "markdown", "md" }
return {
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && npm install",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" },
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
