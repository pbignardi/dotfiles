-- mini.pick custom pickers
--
-- Define the following custom pickers
-- - files_fd
-- - buffers (for open buffers)
-- - file_diagnostic
-- - pick_pickers

local files_fd = function()
  local show = function(buf_id, items, query)
    MiniPick.default_show(buf_id, items, query, { show_icons = true })
  end

  local opts = { source = { name = "All Files", show = show } }
  return MiniPick.builtin.cli({
    command = {
      "fd",
      "--type=f",
      "--color=never",
      "--no-ignore",
      "--hidden",
      "--follow",
      "--exclude",
      ".git",
    },
  }, opts)
end

local buffers = function()
  -- generate items
  local items, cwd = {}, vim.fn.getcwd()
  local curr_buf_id = vim.fn.bufnr()
  for _, buf_info in ipairs(vim.fn.getbufinfo()) do
    if buf_info.listed == 1 and buf_info.bufnr ~= curr_buf_id then
      local name = vim.fs.relpath(cwd, buf_info.name) or buf_info.name
      table.insert(items, {
        text = name,
        bufnr = buf_info.bufnr,
        _lastused = buf_info.lastused,
        _is_curr = (buf_info.bufnr == curr_buf_id),
      })
    end
  end

  -- sort by recency - place current at bottom
  table.sort(items, function(a, b)
    if a._is_curr then return false end
    if b._is_curr then return true end
    return a._lastused > b._lastused
  end)

  -- define custom show
  local show = function(buf_id, items_to_show, query)
    MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
  end

  local opts = {
    source = { name = "Buffers", items = items, show = show },
    mappings = {
      mark = "<M-x>",
      close_buffer = {
        char = "<C-x>",
        func = function()
          local matches = MiniPick.get_picker_matches() or {}
          local match_ids = matches.all_inds or {}
          local curr_ind = matches.current_ind or -1
          local curr_buf = matches.current or {}

          -- update match ids
          local filt_match_ids = {}
          for _, id in ipairs(match_ids) do
            if id ~= curr_ind then
              table.insert(filt_match_ids, id)
            end
          end

          -- delete buffer
          local force = false
          local term_match = string.match(curr_buf.text, "^term:/")
          if term_match then
            if vim.fn.confirm("Close terminal?", "No\nYes", 0) > 0 then
              force = true
            end
          end

          vim.api.nvim_buf_delete(curr_buf.bufnr, { force = force })

          -- update picker items
          MiniPick.set_picker_match_inds(filt_match_ids)
        end,
      },
    },
  }
  return MiniPick.start(opts)
end

local file_diagnostic = function()
  MiniExtra.pickers.diagnostic { scope = "current" }
end

local pick_pickers = function()
  local items = vim.tbl_keys(MiniPick.registry)
  table.sort(items)
  local source = { items = items, name = "Pickers", choose = function() end }
  local chosen_picker_name = MiniPick.start { source = source }
  if chosen_picker_name == nil then
    return
  end
  return MiniPick.registry[chosen_picker_name]()
end

-- register custom pickers
Config.later(function()
  -- files picker with fallback
  MiniPick.registry.all_files = files_fd
  -- picker to sort open files by visit
  MiniPick.registry.open_buffers = buffers
  -- diagnostic picker
  MiniPick.registry.file_diagnostic = file_diagnostic
  -- picker to search through pickers
  MiniPick.registry.pickers = pick_pickers
end)

-- TODO: move into mappings.lua
Config.later(function()
  -- files fuzzy finder
  vim.keymap.set("n", "<leader>p", ":Pick git_files<CR>", { desc = "project files" })
  vim.keymap.set("n", "<leader>/", ":Pick open_buffers<CR>", { desc = "open buffers" })
  vim.keymap.set("n", "<leader>fh", ":Pick help<CR>", { desc = "help tags" })
  vim.keymap.set("n", "<leader>ff", ":Pick all_files<CR>", { desc = "files" })
  vim.keymap.set("n", "<leader>fc", ":Pick colorschemes<CR>", { desc = "color schemes" })
  vim.keymap.set("n", "<leader>fg", ":Pick grep_live<CR>", { desc = "grep" })
  vim.keymap.set("n", "<leader>fk", ":Pick git_hunks<CR>", { desc = "git hunks" })
  vim.keymap.set("n", "<leader>df", ":Pick file_diagnostic<CR>", { desc = "diagnostics" })
  vim.keymap.set("n", "<leader>dw", ":Pick diagnostic<CR>", { desc = "diagnostics (workspace)" })
  -- lsp fuzzy finder
  vim.keymap.set("n", "<leader>gd", ":Pick lsp scope='definition'<CR>", { desc = "goto definition" })
  vim.keymap.set("n", "<leader>gr", ":Pick lsp scope='references'<CR>", { desc = "references" })
  vim.keymap.set("n", "<leader>gI", ":Pick lsp scope='implementation'<CR>", { desc = "goto implementation" })
  vim.keymap.set("n", "<leader>gy", ":Pick lsp scope='type_definition'<CR>", { desc = "goto type definition" })
  vim.keymap.set("n", "<leader>gD", ":Pick lsp scope='declaration'<CR>", { desc = "goto declaration" })
  vim.keymap.set("n", "<leader>gs", ":Pick lsp scope='document_symbol'<CR>", { desc = "document symbols" })
  vim.keymap.set("n", "<leader>gS", ":Pick lsp scope='workspace_symbol_live'<CR>", { desc = "workspace symbols" })
end)
