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
vim.keymap.set("n", "<leader>f", require("oil").toggle_float, { desc = "Open file explorer" })

-- telescope
local ts_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sg", ts_builtin.live_grep, { desc = "Search in the content of files" })
vim.keymap.set("n", "<leader>sf", ts_builtin.find_files, { desc = "Find file" })
vim.keymap.set("n", "<leader>/", ts_builtin.buffers, { desc = "Select currently open buffers" })
vim.keymap.set("n", "<leader>tc", ts_builtin.colorscheme, { desc = "Select currently open buffers" })

-- neotree
vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle<CR>", { desc = "Toggle file system explorer" })

-- lsp
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Open Code Actions" })

-- noice
vim.keymap.set("n", "<leader>qq", vim.cmd.NoiceDismiss, { desc = "Dismiss Noice Notifications" })
