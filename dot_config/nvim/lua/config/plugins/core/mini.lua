return {
	"echasnovski/mini.nvim",
	enabled = true,
	config = function()
		-- statusline
		require("mini.statusline").setup()

		-- ai textobjects
		require("mini.ai").setup()

		-- comment
		require("mini.comment").setup()

		-- icons
		require("mini.icons").setup()

		-- indent line
		require("mini.indentscope").setup({
			delay = 20,
			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
			symbol = "▎",
		})

		-- trim whitespaces
		require("mini.trailspace").setup()

		-- autogenerate open-close text objects
		require("mini.pairs").setup()

		-- surround
		require("mini.surround").setup()
	end,
}
