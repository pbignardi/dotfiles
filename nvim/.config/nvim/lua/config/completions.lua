-- COMPLETION PLUGIN
-- Use blink.cmp for completion menu

require("blink.cmp").setup {
  keymap = { preset = "enter" },
  appearance = {
    nerd_font_variant = "mono",
  },
  sources = {},
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = "none",
      },
    },
    menu = {
      scrollbar = true,
      draw = {
        columns = {
          { "kind_icon" },
          { "kind" },
          { "label", "label_description", gap = 1 },
        },
      },
      window = {
        border = "none",
      },
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      border = "none",
    },
  },
}
