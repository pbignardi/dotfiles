-- COMPLETION PLUGIN
-- Use blink.cmp for completion menu

MiniDeps.later(MiniIcons.tweak_lsp_kind)

local use_blink = true

if not use_blink then
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require("mini.completion").setup {
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = process_items,
    },
  }

  local on_attach = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end

  local gr = vim.api.nvim_create_augroup("custom-config", {})
  vim.api.nvim_create_autocmd("LspAttach", {
    group = gr,
    pattern = nil,
    callback = on_attach,
    desc = "Set omnifunc",
  })
  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
else
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
end
