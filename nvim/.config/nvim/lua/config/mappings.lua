local map = vim.keymap.set

-- misc
map("n", "<leader>so", ":source %<CR>", { desc = "source current file" })
map("v", "<leader>x", ":lua<CR>", { desc = "run current Lua selection" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })

-- buffer
map("n", "j", "v:count == 0? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up" })
map("n", "<C-d>", "<C-d>zz", { desc = "half page down" })
map("n", "<leader>x", ":bd<CR>", { desc = "close current buffer" })
