-- STARTUP INTERFACE
-- setup similar to dashboard-nvim

local pick_dir = function(cwd)
  local filter = function(item)
    return item.fs_type == "directory"
  end
  local opts = {
    mappings = {
      select_target = {
        char = "<C-CR>",
        func = function()
          return MiniPick.get_picker_matches().current
        end,
      },
    },
  }
  return function()
    local target = MiniExtra.pickers.explorer({
      cwd = cwd,
      filter = filter,
    }, opts)
    vim.fn.chdir(vim.fs.normalize(target.path))
    vim.notify("Changed dir to: " .. target.path)
  end
end

local starter = require "mini.starter"
MiniDeps.now(function()
  starter.setup {
    header = "",
    footer = "",
    items = {
      starter.sections.sessions(),
      { name = "Home", section = "Open directory", action = pick_dir(vim.fs.normalize "~") },
      starter.sections.builtin_actions(),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.aligning("center", "center"),
    },
  }
end)
