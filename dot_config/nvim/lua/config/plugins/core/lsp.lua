local ensure_installed = { "lua_ls", "pyright", "ruff" }

local servers = {
	gopls = {},
	ruff = {
		init_options = {
			settings = {
				linelength = 80,
			},
		},
	},
	pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

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
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
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
