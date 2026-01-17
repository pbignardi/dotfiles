if not vim.g.vscode then
	return {}
end

local enabled = {
	"lazy.nvim",
	"mini.ai",
	"mini.comment",
	"mini.move",
	"mini.pairs",
	"mini.surround",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
	"ts-comments.nvim",
}

local vscode = require("vscode")
local lazy_config = require("lazy.core.config")
lazy_config.options.checker.enabled = false
lazy_config.options.change_detection.enabled = false
lazy_config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- add vscode keymaps
vim.api.nvim_create_autocmd("User", {
	callback = function()
		vim.keymap.set("n", "<leader>sg", function()
			vscode.call("workbench.action.findInFiles")
		end)
		vim.keymap.set("n", "<leader>sf", function()
			vscode.call("workbench.action.quickOpen")
		end)
		vim.keymap.set("n", "<leader>/", function()
			vscode.call("workbench.action.quickOpen")
		end)
		vim.keymap.set("n", "gd", function()
			vscode.call("editor.action.revealDefinition")
		end)
		vim.keymap.set("n", "<leader>ss", function()
			vscode.call("workbench.action.goToSymbol")
		end)

		-- toggle integrated terminal
		for _, lhs in ipairs({ "<leader>ft", "<leader>fT", "<c-/>" }) do
			vim.keymap.set("n", lhs, function()
				vscode.call("workbench.action.terminal.toggleTerminal")
			end)
		end

		vim.keymap.set("n", "<leader>nb", function()
			vscode.call("workbench.action.nextEditor")
		end)
		vim.keymap.set("n", "<leader>pb", function()
			vscode.call("workbench.action.previousEditor")
		end)
	end,
})

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { highlight = { enable = false } },
	},
}
