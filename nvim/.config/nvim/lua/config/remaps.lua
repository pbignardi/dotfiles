-- Add here any remaps that use only internal neovim functionality.
-- Any plugin-specific mapping must go into its own relevant plugin file.

-- misc
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Run current Lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Run current Lua selection" })
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save file" })

-- buffer
vim.keymap.set("n", "j", "v:count == 0? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
