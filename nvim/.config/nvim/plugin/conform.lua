-- conform.nvim formatter interface

-- install conform.nvim
vim.pack.add({"https://github.com/stevearc/conform.nvim"})

-- setup conform
Config.later(function()
  require("conform").setup()

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format { bufnr = args.buf }
    end,
  })
end)
