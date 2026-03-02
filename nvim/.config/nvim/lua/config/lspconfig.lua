-- LSPCONFIG SETUP

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
-- there is a plugin defining mappings, maybe we should suppress them
local lsp_keymaps = {
  { "n", "gd", vim.lsp.buf.definition, { desc = "Goto definition", has = "definition" } },
  { "n", "gr", vim.lsp.buf.references, { desc = "References", has = "references" } },
  { "n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation", has = "implementation" } },
  { "n", "gy", vim.lsp.buf.type_definition, { desc = "Goto type definition", has = "typeDefinition" } },
  { "n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration", has = "declaration" } },
  { "n", "gs", vim.lsp.buf.document_symbol, { desc = "Document symbols", has = "declaration" } },
  { "n", "gS", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols", has = "declaration" } },
  { "n", "K", vim.lsp.buf.hover, { desc = "Hover", has = "hover" } },
  { "i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help", has = "signatureHelp" } },
  { "n", "gc", vim.lsp.buf.code_action, { desc = "Code action", has = "codeAction" } },
  { "n", "gn", vim.lsp.buf.rename, { desc = "Rename", has = "rename" } },
}

MiniDeps.later(function()
  for _, kmap in ipairs(lsp_keymaps) do
    local mode = kmap[1]
    local lhs = kmap[2]
    local rhs = kmap[3]
    local opts = kmap[4]

    vim.keymap.set(mode, lhs, rhs, { desc = "LSP " .. opts.desc })
  end
end)
