local filetype = { "java" }
return {
	"nvim-java/nvim-java",
	ft = filetype,
	config = function()
		require("java").setup()
		vim.lsp.config("jdtls", {
			settings = {
				java = {
					configuration = {
						runtimes = {
							{
								name = "JavaSE-21",
								path = "/usr/lib/jvm/java-21-openjdk",
								default = true,
							},
						},
					},
				},
			},
		})
		vim.lsp.enable("jdtls")
	end,
}
