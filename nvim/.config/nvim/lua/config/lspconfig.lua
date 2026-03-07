-- LSPCONFIG SETUP
local map = vim.keymap.set

_G.lsp_by_ft = {
  lua = { "lua_ls" },
  python = { "pyrefly" },
  matlab = { "matlab_ls" },
}

_G.formatter_by_ft = {
  lua = { "stylua" },
  python = { "ruff" },
}

-- setup mason asynchronously
MiniDeps.now(function()
  require("mason").setup {
    ui = {
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
      width = 0.65,
    },
  }
end)

MiniDeps.later(function()
  -- assemble the ensure_installed table
  local required = {}

  for _, pkgs in pairs(_G.lsp_by_ft) do
    for _, pkg in ipairs(pkgs) do
      table.insert(required, pkg)
    end
  end

  for _, pkgs in pairs(_G.formatter_by_ft) do
    for _, pkg in ipairs(pkgs) do
      table.insert(required, pkg)
    end
  end

  require("mason-lspconfig").setup {
    automatic_enable = true,
    ensure_installed = required,
  }
end)

-- set custom lsp keymaps
MiniDeps.later(function()
  map("n", "<leader>gd", ":Pick lsp scope='definition'", { desc = "goto definition" })
  map("n", "<leader>gr", ":Pick lsp scope='references'", { desc = "references" })
  map("n", "<leader>gI", ":Pick lsp scope='implementation'", { desc = "goto implementation" })
  map("n", "<leader>gy", ":Pick lsp scope='type_definition'", { desc = "goto type definition" })
  map("n", "<leader>gD", ":Pick lsp scope='declaration'", { desc = "goto declaration" })
  map("n", "<leader>gs", ":Pick lsp scope='document_symbol'", { desc = "document symbols" })
  map("n", "<leader>gS", ":Pick lsp scope='workspace_symbol_live'", { desc = "workspace symbols" })
  map("n", "K", vim.lsp.buf.hover, { desc = "hover" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "signature help" })
  map("n", "<leader>gc", vim.lsp.buf.code_action, { desc = "code action" })
  map("n", "<leader>gn", vim.lsp.buf.rename, { desc = "rename" })
end)
