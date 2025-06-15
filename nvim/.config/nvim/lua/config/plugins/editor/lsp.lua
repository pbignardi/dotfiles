local lsp_servers = {
	gopls = {},
	pyright = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	clangd = {},
	bashls = {},
	jdtls = {},
}

return {
	-- Mason
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
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
				automatic_enable = true,
				ensure_installed = vim.tbl_keys(lsp_servers),
			})

			require("lspconfig").julials.setup({})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local fzflua = require("fzf-lua")

					local lspkeymap = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { desc = desc, buffer = ev.buf })
					end

					lspkeymap("<leader>rn", vim.lsp.buf.rename, "Rename")
					lspkeymap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
					lspkeymap("gd", vim.lsp.buf.definition, "Goto Definition")
					lspkeymap("gr", fzflua.lsp_references, "Goto References")
					lspkeymap("gI", fzflua.lsp_implementations, "Goto Implementation")
					lspkeymap("gD", vim.lsp.buf.type_definition, "Type Definition")
					lspkeymap("gs", fzflua.lsp_document_symbols, "Document Symbols")
					lspkeymap("<leader>ws", fzflua.lsp_workspace_symbols, "Workspace Symbols")
					lspkeymap("K", vim.lsp.buf.hover, "Hover Documentation")
					lspkeymap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
				end,
			})
		end,
	},
}
