return {
	"echasnovski/mini.nvim",
	enabled = true,
	config = function()
		-- notify
		local notify = require("mini.notify")
		notify.setup({
			content = {
				format = function(notif)
					local content = ""
					if notif.level == "INFO" then
						content = content .. "  Info - "
					elseif notif.level == "ERROR" then
						content = content .. "  Error - "
					elseif notif.level == "WARN" then
						content = content .. "  Warning - "
					elseif notif.level == "DEBUG" then
						content = content .. "  Debug - "
					else
						content = ""
					end
					return content .. notif.msg .. " "
				end,
			},
			window = {
				config = {
					border = "rounded",
				},
				max_width_share = 0.4,
			},
		})
		vim.notify = notify.make_notify()

		-- hipatterns
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		-- clue (which key)
		local miniclue = require("mini.clue")
		miniclue.setup({})

		-- git support
		require("mini.git").setup()

		-- diff
		require("mini.diff").setup({
			view = {
				style = "sign",
				signs = { add = "┃", change = "┃", delete = "▁" },
			},
		})

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
			}, "\n"),
		})

		-- tabline
		require("mini.tabline").setup({
			set_vim_settings = false,
		})
	end,
}
