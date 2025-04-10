-- misc
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current Lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run current Lua selection" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })

-- buffer
vim.keymap.set("n", "j", "v:count == 0? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<leader>ts", require("mini.trailspace").trim, { desc = "Trim trailing spaces" })

-- files
local toggle_files = function(...)
	if not MiniFiles.close() then
		MiniFiles.open(...)
	end
end
vim.keymap.set("n", "<leader>f", toggle_files, { desc = "Open file explorer" })

-- fuzzy finder
local fzflua = require("fzf-lua")
vim.keymap.set("n", "<leader>sg", fzflua.grep, { desc = "Search in the content of files" })
vim.keymap.set("n", "<leader>sf", fzflua.files, { desc = "Find file" })
vim.keymap.set("n", "<leader>sh", fzflua.helptags, { desc = "Search in help" })
vim.keymap.set("n", "<leader>/", fzflua.buffers, { desc = "Select currently open buffers" })
vim.keymap.set("n", "<leader>tc", fzflua.colorschemes, { desc = "Select currently open buffers" })

-- lsp
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Open Code Actions" })

-- noice
vim.keymap.set("n", "<leader>qq", vim.cmd.NoiceDismiss, { desc = "Dismiss Noice Notifications" })
