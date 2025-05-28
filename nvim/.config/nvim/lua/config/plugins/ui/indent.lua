return {
    'echasnovski/mini.indentscope',
    version = false,
    config = function ()
		require("mini.indentscope").setup({
			delay = 20,
			draw = {
				animation = require("mini.indentscope").gen_animation.none(),
			},
			symbol = "▎",
		})

    end
}
