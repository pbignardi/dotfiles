-- mini files configuration
Config.later(function()
  local toggleFiles = function()
    return not MiniFiles.close() and MiniFiles.open()
  end
  local map_split = function(buf_id, lhs, direction)
    local rhs = function()
      local cur_target = MiniFiles.get_explorer_state().target_window
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. " split")
        return vim.api.nvim_get_current_win()
      end)
      MiniFiles.set_target_window(new_target)
      MiniFiles.go_in()
    end
    local desc = "Split " .. direction
    vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      map_split(buf_id, "<C-s>", "belowright vertical")
      map_split(buf_id, "<C-h>", "belowright horizontal")
      map_split(buf_id, "<C-t>", "tab")
    end,
  })

  vim.keymap.set("n", "<leader>e", toggleFiles, { desc = "file explorer" })
end)
