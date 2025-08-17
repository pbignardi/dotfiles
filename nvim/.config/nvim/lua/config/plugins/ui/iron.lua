return {
	"Vigemus/iron.nvim",
	ft = { "sh", "python" },
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		local common = require("iron.fts.common")

		iron.setup({
			config = {
				scratch_repl = true,
				repl_definition = {
					sh = {
						command = { "zsh" },
					},
					python = {
						command = { "ipython", "--no-autoindent" },
						format = common.bracketed_paste_python,
						block_dividers = { "# %%", "#%%" },
					},
				},
				repl_filetype = function(bufnr, ft)
					return ft
				end,
				repl_open_cmd = {
					view.split.vertical.rightbelow("%40"),
					view.split.rightbelow("%25"),
				},
			},
			keymaps = {
				toggle_repl = "<space>ir",
				toggle_repl_with_cmd_1 = "<space>ih",
				toggle_repl_with_cmd_2 = "<space>iv",
				restart_repl = "<space>iR",
				visual_send = "<space>is",
				send_file = "<space>if",
				send_line = "<space>il",
				send_code_block = "<space>ib",
				send_code_block_and_move = "<space>im",
				interrupt = "<space>iC",
				exit = "<space>iq",
				clear = "<space>iL",
			},
			ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
		})
	end,
}
