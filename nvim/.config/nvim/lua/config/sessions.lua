-- setup mini sessions
MiniDeps.now(require("mini.sessions").setup)

local write_session = function()
  MiniSessions.write(vim.fn.input "Session name: ")
end

MiniDeps.later(function()
  vim.keymap.set("n", "<leader>so", MiniSessions.select, { desc = "Open session" })
  vim.keymap.set("n", "<leader>sn", write_session, { desc = "New session" })
  vim.keymap.set("n", "<leader>sw", MiniSessions.write, { desc = "Write session" })
  vim.keymap.set("n", "<leader>sd", MiniSessions.delete, { desc = "Delete session" })
end)
