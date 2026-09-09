-- Completions with blink.cmp for completion menu

-- install blink.cmp
vim.pack.add({
    {
        src = "https://github.com/Saghen/blink.cmp",
        version = vim.version.range("1.*")
    }
})

local config = {
    keymap = { preset = "enter" },
    appearance = { use_nvim_cmp_as_default = false },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "none" },
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
      list = { selection = { preselect = true, auto_insert = true } },
    },
    signature = { enabled = true, window = { border = "none" } },
}


Config.later(function() require("blink.cmp").setup(config) end)
