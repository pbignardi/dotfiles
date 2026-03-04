-- STARTUP INTERFACE
-- setup similar to dashboard-nvim

local starter = require "mini.starter"
MiniDeps.now(function()
  starter.setup {
    footer = "",
    items = {
      starter.sections.sessions(),
      starter.sections.pick(),
      starter.sections.builtin_actions(),
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(),
      starter.gen_hook.aligning("center", "center"),
    },
  }
end)
