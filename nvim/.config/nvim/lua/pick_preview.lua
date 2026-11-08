-- Always-visible preview window for mini.pick.
--
-- Usage (in mini.pick setup):
--   window = { config = require("pick_preview").win_config }
--
-- The picker and the preview share one centered box. If the editor is wide
-- enough the preview goes to the right of the picker, otherwise below it.

local M = {}

-- Box size relative to the editor, and the columns/lines ratio above which
-- the preview is placed on the side (terminal cells are ~2x taller than wide)
local BOX_WIDTH, BOX_HEIGHT, SIDE_RATIO = 0.9, 0.8, 2.5

-- Compute picker and preview window configs (sizes exclude a 1-cell border)
local layout = function()
  local cols, lines = vim.o.columns, vim.o.lines - vim.o.cmdheight - 1
  local W, H = math.floor(BOX_WIDTH * cols), math.floor(BOX_HEIGHT * lines)
  local row, col = math.floor((lines - H) / 2), math.floor((cols - W) / 2)

  if cols > SIDE_RATIO * lines then
    local w = math.floor(W / 2)
    return {
      picker = { row = row, col = col, width = w - 2, height = H - 2 },
      preview = { row = row, col = col + w, width = W - w - 2, height = H - 2 },
    }
  end
  local h = math.floor(H / 2)
  return {
    picker = { row = row, col = col, width = W - 2, height = h - 2 },
    preview = { row = row + h, col = col, width = W - 2, height = H - h - 2 },
  }
end

-- To be used as mini.pick's `window.config`
M.win_config = function()
  return vim.tbl_extend("force", layout().picker, { anchor = "NW" })
end

local win, preview, last
local ns = vim.api.nvim_create_namespace "pick_preview"
local timer = vim.uv.new_timer()

local new_buf = function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  return buf
end

local preview_config = function()
  local opts = { relative = "editor", anchor = "NW", focusable = false, style = "minimal", zindex = 251 }
  return vim.tbl_extend("force", layout().preview, opts)
end

-- Show preview of the current item (if it changed)
local update = function()
  if not (win and vim.api.nvim_win_is_valid(win) and MiniPick.is_picker_active()) then
    return
  end
  local item = (MiniPick.get_picker_matches() or {}).current
  if item == last then
    return
  end
  last = item

  local buf = new_buf()
  vim.api.nvim_win_set_buf(win, buf)
  if item ~= nil then
    pcall(preview, buf, item)
  end
  vim.cmd.redraw()
end

-- Debounce, so that fast typing/scrolling doesn't preview every item
local schedule_update = function()
  timer:start(30, 0, vim.schedule_wrap(update))
end

local group = vim.api.nvim_create_augroup("pick_preview", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MiniPickStart",
  callback = function()
    preview = MiniPick.get_picker_opts().source.preview or MiniPick.default_preview
    last = {} -- sentinel: force first update
    win = vim.api.nvim_open_win(new_buf(), false, preview_config())
    -- Picker reads keys with `getcharstr()`, so there is no event for moving
    -- the current item: check after every key instead
    vim.on_key(schedule_update, ns)
    schedule_update()
  end,
})

vim.api.nvim_create_autocmd("User", { group = group, pattern = "MiniPickMatch", callback = schedule_update })

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "MiniPickStop",
  callback = function()
    vim.on_key(nil, ns)
    timer:stop()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    win = nil
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  callback = function()
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_config(win, preview_config())
    end
  end,
})

return M
