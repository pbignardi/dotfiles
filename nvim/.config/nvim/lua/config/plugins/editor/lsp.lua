local fzflua = require("fzf-lua")

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = true },
			{ "mason-org/mason-lspconfig.nvim", opts = true },
			"saghen/blink.cmp",
		},
		opts = {
			servers = {
				gopls = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				clangd = {},
				bashls = {},
				jdtls = {},
				ruff = {},
				emmet_language_server = {},
				ts_ls = {},
			},
            --stylua: ignore
            keys = {
                { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
                { "gr", fzflua.lsp_references, desc = "References", has = "references"},
                { "gI", fzflua.lsp_implementations, desc = "Goto Implementation", has = "implementation"},
                { "gy", fzflua.lsp_typedefs, desc = "Goto T[y]pe Definition", has = "typeDefinition" },
                { "gD", fzflua.lsp_declarations, desc = "Goto Declaration", has = "declaration"},
                { "K", function() return vim.lsp.buf.hover() end, desc = "Hover", has = "hover"},
                { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
                { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
                { "<leader>ca", fzflua.lsp_code_actions, desc = "Code Action", has = "codeAction" },
                { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            },
		},
		config = function(_, opts)
			-- custom lsp setups
			vim.lsp.config["julials"] = {
				on_new_config = function(new_config, _)
					local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
					if (vim.uv.fs_stat(julia) or {}).type == "file" then
						vim.notify("Hello!")
						new_config.cmd[1] = julia
					end
				end,
			}

			-- setup lsp with mason-lspconfig
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = opts.servers,
			})

			-- set custom lsp keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

					for _, entry in ipairs(opts.keys) do
						local mode = entry.mode or "n"
						assert(type(mode) == "string", "mode must be a string")

						if entry.has ~= nil and client:supports_method("textDocument/" .. entry.has) then
							vim.keymap.set(mode, entry[1], entry[2], { desc = entry.desc, buffer = ev.buf })
						end
						if entry.has == nil then
							vim.keymap.set(mode, entry[1], entry[2], { desc = entry.desc, buffer = ev.buf })
						end
					end
				end,
			})
		end,
	},
}
