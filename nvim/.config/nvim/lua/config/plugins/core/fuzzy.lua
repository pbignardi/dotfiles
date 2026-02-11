local watch_dirs = {
}
local projects = {}

for _, dir in ipairs(watch_dirs) do
	for _, subdir in ipairs(vim.fn.glob(dir .. "/*", true, true)) do
		if vim.fn.isdirectory(subdir) then
			table.insert(projects, subdir)
		end
	end
end

local fuzzy_files = function()
	require("mini.pick").builtin.files({ tool = "fallback" })
end

local fuzzy_gitfiles = function()
	require("mini.extra").pickers.git_files()
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

local fuzzy_builtin = function() end

local fuzzy_diff = function()
	require("mini.extra").pickers.git_hunks()
end

local fuzzy_projects = function()
	local pick = require("mini.pick")
	pick.start({
		source = {
			items = projects,
			name = "Projects",
			choose = function(item)
				vim.cmd("cd " .. vim.fn.fnameescape(item))
			end,
		},
	})
end

return {
	{
		"nvim-mini/mini.pick",
		version = false,
		opts = {
			window = {
				config = function()
					local height = math.floor(0.618 * vim.o.lines)
					local width = math.floor(0.618 * vim.o.columns)
					return {
						anchor = "NW",
						height = height,
						width = width,
						row = math.floor(0.5 * (vim.o.lines - height)),
						col = math.floor(0.5 * (vim.o.columns - width)),
						border = "rounded",
					}
				end,
			},
		},
		keys = {
			{ "<leader>/", fuzzy_buffers, desc = "Open buffers" },
			{ "<leader>sf", fuzzy_files, desc = "Files" },
			{ "<leader>p", fuzzy_gitfiles, desc = "Project files" },
			{ "<leader>w", fuzzy_projects, desc = "Open project" },
			{ "<leader>sg", fuzzy_grep, desc = "Grep" },
			{ "<leader>sh", fuzzy_help, desc = "Help" },
			{ "<leader>sc", fuzzy_colorschemes, desc = "Colorschemes" },
			{ "<leader>sb", fuzzy_builtin, desc = "Built-in" },
			{ "<leader>sd", fuzzy_diff, desc = "Git diff" },
		},
	},
}
