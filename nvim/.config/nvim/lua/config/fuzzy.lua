-- snacks.nvim picker setup
MiniDeps.now(function()
  vim.keymap.set("n", "<leader>u", Snacks.picker.pickers, { desc = "Snacks pickers" })
end)

-- add picker to search through pickers
MiniDeps.later(function()
  local buffers = function()
    Snacks.picker.buffers {
      current = false,
    }
  end
  -- general pickers
  vim.keymap.set("n", "<leader>p", Snacks.picker.git_files, { desc = "project files" })
  vim.keymap.set("n", "<leader>/", buffers, { desc = "open buffers" })
  vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "help tags" })
  vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "files" })
  vim.keymap.set("n", "<leader>fc", Snacks.picker.colorschemes, { desc = "color schemes" })
  vim.keymap.set("n", "<leader>fg", Snacks.picker.grep, { desc = "grep" })
  vim.keymap.set("n", "<leader>fd", Snacks.picker.git_diff, { desc = "git hunks" })
  vim.keymap.set("n", "<leader>df", Snacks.picker.diagnostics_buffer, { desc = "diagnostics" })
  vim.keymap.set("n", "<leader>dw", Snacks.picker.diagnostics, { desc = "diagnostics (workspace)" })
  -- lsp stuff
  vim.keymap.set("n", "<leader>gd", Snacks.picker.lsp_definitions, { desc = "goto definition" })
  vim.keymap.set("n", "<leader>gr", Snacks.picker.lsp_references, { desc = "references" })
  vim.keymap.set("n", "<leader>gI", Snacks.picker.lsp_implementations, { desc = "goto implementation" })
  vim.keymap.set("n", "<leader>gy", Snacks.picker.lsp_type_definitions, { desc = "goto type definition" })
  vim.keymap.set("n", "<leader>gD", Snacks.picker.lsp_declarations, { desc = "goto declaration" })
  vim.keymap.set("n", "<leader>gs", Snacks.picker.lsp_symbols, { desc = "document symbols" })
  vim.keymap.set("n", "<leader>gS", Snacks.picker.lsp_workspace_symbols, { desc = "workspace symbols" })
end)
