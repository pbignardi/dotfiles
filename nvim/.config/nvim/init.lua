-- use _G.config from minimax for persistent data across config scripts
_G.Config = {}

-- create custom config autogroup
local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
    local opts = { group = gr, pattern = pattern, callback = callback, desc = desc}
    vim.api.nvim_create_autocmd(event, opts)
end

-- install mini.nvim
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- configure now and later functions
local misc = require("mini.misc")
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:'.. ft, f) end


-- install external plugins
-- MiniDeps.add { source = "NeogitOrg/neogit", depends = { "nvim-lua/plenary.nvim" } }
-- MiniDeps.add { source = "mfussenegger/nvim-dap" }
-- MiniDeps.add { source = "nvim-java/nvim-java", depends = { "MunifTanjim/nui.nvim" } }

-- MiniDeps.add { source = "neovim/nvim-lspconfig" }
-- MiniDeps.add { source = "stevearc/conform.nvim" }
--
-- MiniDeps.add { source = "TheNiteCoder/mountaineer.vim" }
