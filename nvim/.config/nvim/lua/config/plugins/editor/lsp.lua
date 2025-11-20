local fzflua = require("fzf-lua")
local icons = require("config.icons")

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = true },
			{ "mason-org/mason-lspconfig.nvim", opts = true },
			"saghen/blink.cmp",
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.error,
						[vim.diagnostic.severity.WARN] = icons.warn,
						[vim.diagnostic.severity.HINT] = icons.hint,
						[vim.diagnostic.severity.INFO] = icons.info,
					},
				},
			},
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
			-- set diagnostics
			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			-- custom lsp setups
			vim.lsp.config("julials", {
				cmd = {
					"julia",
					"--project=" .. "~/.julia/environments/lsp/",
					"--startup-file=no",
					"--history-file=no",
					"-e",
					[[
                        using Pkg
                        Pkg.instantiate()
                        using LanguageServer
                    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
                    project_path = let
                        dirname(something(
                            ## 1. Finds an explicitly set project (JULIA_PROJECT)
                            Base.load_path_expand((
                                p = get(ENV, "JULIA_PROJECT", nothing);
                                    p === nothing ? nothing : isempty(p) ? nothing : p
                                )),
                                    ## 2. Look for a Project.toml file in the current working directory,
                                    ##    or parent directories, with $HOME as an upper boundary
                                    Base.current_project(),
                                    ## 3. First entry in the load path
                                    get(Base.load_path(), 1, nothing),
                                    ## 4. Fallback to default global environment,
                                    ##    this is more or less unreachable
                                Base.load_path_expand("@v#.#"),
                            ))
                        end
                                @info "Running language server" VERSION pwd() project_path depot_path
                                server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
                    server.runlinter = true
                        run(server)
                    ]],
				},
				filetypes = { "julia" },
				root_markers = { "Project.toml", "JuliaProject.toml" },
				settings = {},
			})
			vim.lsp.enable("julials")

			-- setup lsp with mason-lspconfig
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = vim.tbl_keys(opts.servers),
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
