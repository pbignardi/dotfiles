-- COMPLETION PLUGIN
-- Use blink.cmp for completion menu

MiniDeps.later(MiniIcons.tweak_lsp_kind)

MiniDeps.now(function()
  require("blink.cmp").setup {
    keymap = { preset = "enter" },
    appearance = {
      nerd_font_variant = "mono",
      use_nvim_cmp_as_default = false,
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
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
end)
