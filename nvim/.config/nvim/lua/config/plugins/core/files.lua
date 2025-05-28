return {
	"echasnovski/mini.files",
	version = false,
	opts = {},
	config = function()
		require("mini.files").setup()

		vim.api.nvim_create_autocmd("User", {
			pattern = "MiniFilesWindowOpen",
			callback = function(args)
				local win_id = args.data.win_id

				-- Customize window-local settings
				vim.wo[win_id].winblend = 50
				local config = vim.api.nvim_win_get_config(win_id)
				config.border = "rounded"
				vim.api.nvim_win_set_config(win_id, config)
			end,
		})
	end,
}
