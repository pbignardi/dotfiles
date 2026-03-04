-- STARTUP INTERFACE
-- setup similar to dashboard-nvim

-- custom mini picker to cd into a directory and create a session there
local change_dir = function()
  local matches = MiniPick.get_picker_matches()
  if not matches.current then
    return true
  end
  -- vim.fn.chdir(matches.current.path)
  print("Changed directory to: " .. vim.fn.getcwd())
  return true
end

local cwd = { "/" }

local open_directory = function()
  MiniExtra.pickers.explorer({ cwd = cwd }, {
    mappings = {
      execute = {
        char = "<C-CR>",
        func = change_dir,
      },
    },
  })
end

local starter = require "mini.starter"
MiniDeps.now(function()
  starter.setup {
    header = "",
    footer = "",
    items = {
      starter.sections.sessions(),
      { name = "Directory", section = "Open", action = open_directory },
      { name = "File", section = "Open", action = function() end },
      starter.sections.builtin_actions(),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.aligning("center", "center"),
    },
  }
end)
