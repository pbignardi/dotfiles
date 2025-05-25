return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "MoreMsg", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "Directory", linehl = "", numhl = "" })
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		---@module 'dap-view'
		---@type dapview.Config
		opts = {},
	},
	-- python debug adapter protocol
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("uv")
		end,
	},
}
