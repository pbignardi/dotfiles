-- STARTUP INTERFACE
-- setup similar to dashboard-nvim

local pick_dir = function(cwd)
  local filter = function(item)
    return item.fs_type == "directory"
  end
  local opts = {
    mappings = {
      change_directory = {
        char = "<C-CR>",
        func = function()
          local current = MiniPick.get_picker_matches().current or {}
          if current.path then
            local new_cwd = vim.fs.normalize(current.path)
            vim.fn.chdir(new_cwd)
            vim.notify("Changed path to " .. new_cwd)
            return true
          end
          return false
        end,
      },
    },
  }
  return function()
    MiniExtra.pickers.explorer({
      cwd = cwd,
      filter = filter,
    }, opts)
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
