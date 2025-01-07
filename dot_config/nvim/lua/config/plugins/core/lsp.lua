local ensure_installed = { "lua_ls", "pyright", "ruff" }

return {
	-- Mason
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				height = 0.7,
				icons = {
					package_installed = "",
					package_pending = "󱖙",
					package_uninstalled = "",
				},
			},
		},
	},
	-- Nvim configuration
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Hassle free setup of LuaLS
			"folke/lazydev.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
	-- Mason-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})
		end,
	},
}
