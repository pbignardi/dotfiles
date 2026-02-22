-- basic plugins setup

local now, later = MiniDeps.now, MiniDeps.later

-- mini.basics
now(function()
  require("mini.basics").setup()
end)

-- mini.ai
now(function()
  require("mini.ai").setup()
end)

-- mini.surround
now(function()
  require("mini.surround").setup()
end)

-- mini.pairs
now(function()
  require("mini.pairs").setup()
end)

-- mini.icons
now(function()
  require("mini.icons").setup()
end)

-- mini.comment
now(function()
  require("mini.comment").setup()
end)

-- mini.trailspace
now(function()
  require("mini.trailspace").setup()
end)

later(function()
  vim.keymap.set("n", "<leader>ts", require("mini.trailspace").trim, { desc = "Trim trailing spaces" })
end)

-- mini.git
now(function()
  require("mini.git").setup {}
  local format_summary = function(data)
    -- Utilize buffer-local table summary
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or ""
  end

  local au_opts = { pattern = "MiniGitUpdated", callback = format_summary }
  vim.api.nvim_create_autocmd("User", au_opts)
end)

-- MAYBE PLUGINS
-- mini.sessions
