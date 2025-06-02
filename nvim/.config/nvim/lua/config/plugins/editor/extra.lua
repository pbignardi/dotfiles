local trim_trailspace = function()
	vim.cmd(":%s/\r//ge")
	require("mini.trailspace").trim()
end

return {
	{
		-- autogenerate open-close text objects
		"echasnovski/mini.pairs",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		-- comment/uncomment text
		"echasnovski/mini.comment",
		version = false,
		config = function()
			require("mini.comment").setup()
		end,
	},
	{
		-- highlight and delete trailspaces
		"echasnovski/mini.trailspace",
		version = false,
		config = function()
			require("mini.trailspace").setup()
		end,
		keys = {
			{ "<leader>ts", trim_trailspace, desc="Tim trailing spaces" },
		},
	},
	{
		-- define around/inner text objects
		"echasnovski/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
	},
}
