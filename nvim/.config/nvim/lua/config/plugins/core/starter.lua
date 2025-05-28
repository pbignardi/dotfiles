return {
	"echasnovski/mini.starter",
	version = false,
	config = function()
		-- starter
		require("mini.starter").setup({
			header = table.concat({
				[[                          _              ]],
				[[   ____  ___  ____ _   __(_)___ ___      ]],
				[[  / __ \/ _ \/ __ \ | / / / __ `__ \     ]],
				[[ / / / /  __/ /_/ / |/ / / / / / / /     ]],
				[[/_/ /_/\___/\____/|___/_/_/ /_/ /_/      ]],
				[[                                         ]],
			}, "\n"),
		})
	end,
}
