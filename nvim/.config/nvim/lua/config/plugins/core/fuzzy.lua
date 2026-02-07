local fuzzy_files = function()
	require("mini.pick").builtin.files({
		tool = "fallback",
	})
end

local fuzzy_grep = function()
	require("mini.pick").builtin.grep_live()
end

local fuzzy_help = function()
	require("mini.pick").builtin.help()
end

local fuzzy_buffers = function()
	require("mini.pick").builtin.buffers()
end

local fuzzy_colorschemes = function()
	require("mini.extra").pickers.colorschemes()
end

local fuzzy_resume = function()
	require("mini.pick").builtin.resume()
end

local fuzzy_builtin = function()
	require("mini.pick").builtin.builtin()
end

local fuzzy_gitdiff = function()
	require("mini.extra").pickers.git_hunks()
end

return {
	-- fzf lua
	{
		"ibhagwan/fzf-lua",
		enabled = false,
		opts = {
			fzf_colors = {
				["fg"] = { "fg", "CursorLine" },
				["bg"] = { "bg", "Normal" },
				["hl"] = { "fg", "String" },
				["gutter"] = { "bg", "Normal" },
			},
		},
		config = function(_, opts)
			local fzflua = require("fzf-lua")

			fzflua.setup(opts)
			fzflua.register_ui_select()

			return opts
		end,
		keys = {
			{ "<leader>/", fuzzy_buffers, desc = "Open buffers" },
			{ "<leader>sf", fuzzy_files, desc = "Files" },
			{ "<leader>sg", fuzzy_grep, desc = "Grep" },
			{ "<leader>sh", fuzzy_help, desc = "Help" },
			{ "<leader>sc", fuzzy_colorschemes, desc = "Colorschemes" },
			{ "<leader>sr", fuzzy_resume, desc = "Resume" },
			{ "<leader>sb", fuzzy_builtin, desc = "Built-in" },
			{ "<leader>sd", fuzzy_gitdiff, desc = "Built-in" },
		},
	},
	{
		"nvim-mini/mini.pick",
		enabled = true,
		version = false,
		opts = true,
		config = function(_, opts)
			require("mini.pick").setup(opts)
			vim.ui.select = function(items, options, on_choice)
				local start_opts = { window = { config = { width = vim.o.columns } } }
				return MiniPick.ui_select(items, options, on_choice, start_opts)
			end
		end,
		keys = {
			{ "<leader>/", fuzzy_buffers, desc = "Open buffers" },
			{ "<leader>sf", fuzzy_files, desc = "Files" },
			{ "<leader>sg", fuzzy_grep, desc = "Grep" },
			{ "<leader>sh", fuzzy_help, desc = "Help" },
			{ "<leader>sc", fuzzy_colorschemes, desc = "Colorschemes" },
			{ "<leader>sr", fuzzy_resume, desc = "Resume" },
			{ "<leader>sd", fuzzy_gitdiff, desc = "Built-in" },
		},
	},
}
