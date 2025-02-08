return {
	"echasnovski/mini.nvim",
	enabled = true,
	config = function()
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

		-- colors
		require("mini.colors").setup()

        -- starter
		require("mini.starter").setup({
			header = table.concat({
				[[                          _              ]],
				[[   ____  ___  ____ _   __(_)___ ___      ]],
				[[  / __ \/ _ \/ __ \ | / / / __ `__ \     ]],
				[[ / / / /  __/ /_/ / |/ / / / / / / /     ]],
				[[/_/ /_/\___/\____/|___/_/_/ /_/ /_/      ]],
				[[                                         ]],
			}, '\n'),
		})
	end,
}
