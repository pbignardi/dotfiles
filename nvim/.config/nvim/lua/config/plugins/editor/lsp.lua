local lsp_servers = {
	gopls = {},
	pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	julials = {},
	clangd = {},
	bashls = {},
	jdtls = {},
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
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(lsp_servers),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local fzflua = require("fzf-lua")

					local nsetkeymap = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { desc = desc, buffer = ev.buf })
					end

					nsetkeymap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					nsetkeymap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					nsetkeymap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
					nsetkeymap("gr", fzflua.lsp_references, "[G]oto [R]eferences")
					nsetkeymap("gI", fzflua.lsp_implementations, "[G]oto [I]mplementation")
					nsetkeymap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
					nsetkeymap("<leader>ds", fzflua.lsp_document_symbols, "[D]ocument [S]ymbols")
					nsetkeymap("<leader>ws", fzflua.lsp_workspace_symbols, "[W]orkspace [S]ymbols")
					nsetkeymap("K", vim.lsp.buf.hover, "Hover Documentation")
					nsetkeymap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
				end,
			})
		end,
	},
	-- Mason-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({})
		end,
	},
}
