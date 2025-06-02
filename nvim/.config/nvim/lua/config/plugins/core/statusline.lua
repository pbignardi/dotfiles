local icons = require("config.icons")

local active_mini_statusline = function()
	local sl = require("mini.statusline")
	local mode, mode_hl = sl.section_mode({ trunc_width = 10 })
	local git = sl.section_git({ trunc_width = 10 })
	local location = sl.section_location({ trunc_width = 200 })
	local fileinfo = sl.section_fileinfo({ trunc_width = 120 })
	local diff = sl.section_diff({ trunc_width = 75 })

	local diagnostics = sl.section_diagnostics({
		trunc_width = 75,
		icon = "",
		signs = {
			ERROR = icons.error .. " ",
			WARN = icons.warn .. " ",
			INFO = icons.info .. " ",
			HINT = icons.hint .. " ",
		},
	})

	local lsp = sl.section_lsp({ trunc_width = 75, icon = icons.lsp })
	local filename = sl.section_filename({ trunc_width = 75 })
	local search = sl.section_searchcount({ trunc_width = 75 })

	local groups = sl.combine_groups({
		{ hl = mode_hl, strings = { string.upper(mode) } },
		{ hl = "MiniStatuslineDevinfo", strings = { diff, git } },
		{ hl = "MiniStatuslineDiagnostic", strings = { lsp, diagnostics } },
		"%<", -- Mark general truncate point
		{ hl = "MiniStatuslineFilename", strings = { filename } },
		"%=", -- End left alignment
		{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
		{ hl = mode_hl, strings = { search, location } },
	})
	return groups
end

return {
	{
		"echasnovski/mini.statusline",
		version = false,
		config = function()
			require("mini.statusline").setup({
				content = {
					active = active_mini_statusline,
				},
			})
		end,
	},
}
