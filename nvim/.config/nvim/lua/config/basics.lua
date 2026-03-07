-- basic plugins setup

-- mini.basics
MiniDeps.now(require("mini.basics").setup)

-- mini.ai
MiniDeps.now(require("mini.ai").setup)

-- mini.surround
MiniDeps.now(require("mini.surround").setup)

-- mini.pairs
MiniDeps.now(require("mini.pairs").setup)

-- mini.icons
MiniDeps.now(require("mini.icons").setup)

-- mini.comment
MiniDeps.now(require("mini.comment").setup)

-- mini.trailspace
MiniDeps.now(require("mini.trailspace").setup)

MiniDeps.later(function()
  vim.keymap.set("n", "<leader>ts", require("mini.trailspace").trim, { desc = "Trim trailing spaces" })
end)

-- mini.git
MiniDeps.now(function()
  require("mini.git").setup {}
  local format_summary = function(data)
    -- Utilize buffer-local table summary
    local summary = vim.b[data.buf].minigit_summary
    vim.b[data.buf].minigit_summary_string = summary.head_name or ""
  end

  local au_opts = { pattern = "MiniGitUpdated", callback = format_summary }
  vim.api.nvim_create_autocmd("User", au_opts)
end)
