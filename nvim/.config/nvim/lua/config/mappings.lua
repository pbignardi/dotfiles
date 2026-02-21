local map = vim.keymap.set

-- misc
map("n", "<leader>so", ":source %<CR>", { desc = "Source current file" })
map("v", "<leader>x", ":lua<CR>", { desc = "Run current Lua selection" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- buffer
map("n", "j", "v:count == 0? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<leader>x", ":bd<CR>", { desc = "Close current buffer" })
