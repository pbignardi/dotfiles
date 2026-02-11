local function goto_next_start(tobj)
	return function()
		require("nvim-treesitter-textobjects.move").goto_next_start(tobj, "textobjects")
	end
end

local function goto_prv_start(tobj)
	return function()
		require("nvim-treesitter-textobjects.move").goto_previous_start(tobj, "textobjects")
	end
end

local function goto_next_end(tobj)
	return function()
		require("nvim-treesitter-textobjects.move").goto_next_end(tobj, "textobjects")
	end
end

local function goto_prv_end(tobj)
	return function()
		require("nvim-treesitter-textobjects.move").goto_previous_end(tobj, "textobjects")
	end
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		branch = "main",
		build = function()
			local ts = require("nvim-treesitter")
			ts.update(nil, { summary = true })
		end,
		opts = {
			indent = { enable = true },
            auto_install = true,
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"python",
				"javascript",
				"typescript",
				"vimdoc",
				"vim",
				"julia",
				"bash",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			vim.g.no_plugin_maps = true
		end,
		keys = {
			{
				"]f",
				goto_next_start("@function.outer"),
				mode = { "n", "x", "o" },
				desc = "Jump to next function (start)",
			},
			{ "]c", goto_next_start("@class.outer"), mode = { "n", "x", "o" }, desc = "Jump to next class (start)" },
			{
				"]a",
				goto_next_start("@parameter.inner"),
				mode = { "n", "x", "o" },
				desc = "Jump to next parameter (start)",
			},
			{ "]F", goto_next_end("@function.outer"), mode = { "n", "x", "o" }, desc = "Jump to next function (end)" },
			{ "]C", goto_next_end("@class.outer"), mode = { "n", "x", "o" }, desc = "Jump to next class (end)" },
			{
				"]A",
				goto_next_end("@parameter.inner"),
				mode = { "n", "x", "o" },
				desc = "Jump to next parameter (end)",
			},
			{
				"[f",
				goto_prv_start("@function.outer"),
				mode = { "n", "x", "o" },
				desc = "Jump to previous function (start)",
			},
			{ "[c", goto_prv_start("@class.outer"), mode = { "n", "x", "o" }, desc = "Jump to previous class (start)" },
			{
				"[a",
				goto_prv_start("@parameter.inner"),
				mode = { "n", "x", "o" },
				desc = "Jump to previous parameter (start)",
			},
			{
				"[F",
				goto_prv_end("@function.outer"),
				mode = { "n", "x", "o" },
				desc = "Jump to previous function (end)",
			},
			{ "[C", goto_prv_end("@class.outer"), mode = { "n", "x", "o" }, desc = "Jump to previous class (end)" },
			{
				"[A",
				goto_prv_end("@parameter.inner"),
				mode = { "n", "x", "o" },
				desc = "Jump to previous parameter (end)",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = true,
	},
}
