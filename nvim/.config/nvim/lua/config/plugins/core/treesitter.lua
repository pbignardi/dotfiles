local required = {
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
}

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
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- install required parsers
			require("nvim-treesitter").install(required)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
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
