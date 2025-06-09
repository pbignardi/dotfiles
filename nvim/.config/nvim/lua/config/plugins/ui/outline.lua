local toggle_outline = function()
	require("outline").toggle()
end

return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>o", toggle_outline, desc = "Toggle outline" },
	},
	opts = {},
}
