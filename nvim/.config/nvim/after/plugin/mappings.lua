-- Custom mappings

local map_now = function(mode, rhs, lhs, opts)
  Config.now(function()
    vim.keymap.set(mode, rhs, lhs, opts)
  end)
end

local map_later = function(mode, rhs, lhs, opts)
  Config.later(function()
    vim.keymap.set(mode, rhs, lhs, opts)
  end)
end

-- misc
map_later("n", "<leader>so", ":source %<CR>", { desc = "source current file" })
map_later("v", "<leader>xr", ":lua<CR>", { desc = "run current Lua selection" })
map_now("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })

-- buffer
map_now("n", "j", "v:count == 0? 'gj' : 'j'", { expr = true, silent = true })
map_now("n", "k", "v:count == 0? 'gk' : 'k'", { expr = true, silent = true })
map_now("n", "<C-u>", "<C-u>zz", { desc = "half page up" })
map_now("n", "<C-d>", "<C-d>zz", { desc = "half page down" })
map_now("n", "<leader>x", ":bd<CR>", { desc = "close current buffer" })

-- trailspace trim
map_later("n", "<leader>ts", require("mini.trailspace").trim, { desc = "Trim trailing spaces" })

-- fuzzy finder
map_now("n", "<leader>p", ":Pick git_files<CR>", { desc = "project files" })
map_now("n", "<leader>/", ":Pick open_buffers<CR>", { desc = "open buffers" })
map_now("n", "<leader>fh", ":Pick help<CR>", { desc = "help tags" })
map_now("n", "<leader>ff", ":Pick all_files<CR>", { desc = "files" })
map_now("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "grep" })
map_later("n", "<leader>fc", ":Pick colorschemes<CR>", { desc = "color schemes" })
map_later("n", "<leader>fk", ":Pick git_hunks<CR>", { desc = "git hunks" })
map_later("n", "<leader>df", ":Pick file_diagnostic<CR>", { desc = "diagnostics" })
map_later("n", "<leader>dw", ":Pick diagnostic<CR>", { desc = "diagnostics (workspace)" })

-- lsp keybinds
map_later("n", "<leader>gd", ":Pick lsp scope='definition'<CR>", { desc = "goto definition" })
map_later("n", "<leader>gr", ":Pick lsp scope='references'<CR>", { desc = "references" })
map_later("n", "<leader>gI", ":Pick lsp scope='implementation'<CR>", { desc = "goto implementation" })
map_later("n", "<leader>gy", ":Pick lsp scope='type_definition'<CR>", { desc = "goto type definition" })
map_later("n", "<leader>gD", ":Pick lsp scope='declaration'<CR>", { desc = "goto declaration" })
map_later("n", "<leader>gs", ":Pick lsp scope='document_symbol'<CR>", { desc = "document symbols" })
map_later("n", "<leader>gS", ":Pick lsp scope='workspace_symbol_live'<CR>", { desc = "workspace symbols" })

-- buffers
map_now("n", "<leader>x", ":bd", { desc = "wipeout buffer" })
