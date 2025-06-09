local fzf_files = function()
	require("fzf-lua").files()
end

local fzf_grep = function()
	require("fzf-lua").live_grep()
end

local fzf_help = function()
	require("fzf-lua").helptags()
end

local fzf_buffers = function()
	require("fzf-lua").buffers()
end

local fzf_colorschemes = function()
	require("fzf-lua").colorschemes()
end

local fzf_resume = function()
	require("fzf-lua").resume()
end

local fzf_builtin = function()
	require("fzf-lua").builtin()
end

return {
	-- fzf lua
	{
		"ibhagwan/fzf-lua",
		enabled = true,
		opts = {},
		config = function(_, opts)
			local fzflua = require("fzf-lua")

			fzflua.setup(opts)
			fzflua.register_ui_select()

			return opts
		end,
		keys = {
			{ "<leader>/", fzf_buffers, desc = "Open buffers" },
			{ "<leader>sf", fzf_files, desc = "Files" },
			{ "<leader>sg", fzf_grep, desc = "Grep" },
			{ "<leader>sh", fzf_help, desc = "Help" },
			{ "<leader>sc", fzf_colorschemes, desc = "Colorschemes" },
			{ "<leader>sr", fzf_resume, desc = "Resume" },
			{ "<leader>sb", fzf_builtin, desc = "Built-in" },
		},
	},
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Telescope UI Select
	{
		"nvim-telescope/telescope-ui-select.nvim",
		enabled = false,
		opts = {},
		config = function()
			require("telescope").setup({
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
