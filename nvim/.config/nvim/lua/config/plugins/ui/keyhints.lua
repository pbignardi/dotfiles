local buff_local_keymaps = function()
	require("which-key").show({ global = false })
end

local search_keymaps = function() end

local trouble_keymaps = function() end

return {
	{
		"folke/which-key.nvim",
		enabled = true,
		event = "VeryLazy",
		keys = {
			{ "<leader>?", buff_local_keymaps, desc = "Buffer Local Keymaps" },
		},
		config = function()
			local opts = {
				preset = "helix",
			}
			require("which-key").setup(opts)

			-- run keymap setters
			local wk = require("which-key")
			-- search
			local search_icon = { icon = "", hl = "WhichKeyIconOrange", name = "search" }
			wk.add({
				{ "<leader>s", group = "search", icon = search_icon },
				{ "<leader>sc", desc = "colorschemes", icon = "" },
				{ "<leader>sf", desc = "files", icon = "" },
				{ "<leader>sg", desc = "live grep", icon = "" },
				{ "<leader>sh", desc = "helptags", icon = "" },
				{ "<leader>sr", desc = "resume", icon = "" },
				{ "<leader>sb", desc = "built-ins", icon = "" },
			})

			-- trouble
			local trouble_icon = { icon = "", hl = "WhichKeyIconRed", name = "diagnostics" }
			wk.add({
				{ "<leader>x", group = "diagnostics", icon = trouble_icon },
			})
		end,
	},
}
