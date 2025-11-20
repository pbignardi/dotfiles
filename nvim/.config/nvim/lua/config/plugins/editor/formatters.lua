return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					jsonc = { "prettierd", "prettier", stop_after_first = true },
					go = { "gofmt" },
					tex = {},
					julia = { "runic", lsp_format = "fallback" },
					sh = { "shfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					h = { "clang-format" },
				},
				formatters = {
					runic = {
						command = "julia",
						args = {
							"--project=@runic",
							"--startup-file=no",
							"-e",
							"using Runic; exit(Runic.main(ARGS))",
						},
					},
				},
				default_format_opts = {
					timeout_ms = 10000,
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf, async = true })
				end,
			})
		end,
	},
}
