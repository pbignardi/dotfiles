return {
	"echasnovski/mini.icons",
	version = false,
	config = function()
		require("mini.icons").setup()

		local icons = require("config.icons")
		vim.fn.sign_define("DiagnosticSignError", { text = icons.error })
		vim.fn.sign_define("DiagnosticSignWarn", { text = icons.warn })
		vim.fn.sign_define("DiagnosticSignInfo", { text = icons.info })
		vim.fn.sign_define("DiagnosticSignHint", { text = icons.hint })
	end,
}
