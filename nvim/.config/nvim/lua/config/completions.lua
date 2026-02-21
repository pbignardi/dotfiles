-- COMPLETION PLUGIN
-- Use blink.cmp for completion menu

require("blink.cmp").setup {
  keymap = { preset = "enter" },
  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = false,
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
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
      border = "none",
      scrollbar = false,
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
        },
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
