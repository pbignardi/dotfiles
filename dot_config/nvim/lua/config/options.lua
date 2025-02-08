-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.showmatch = true

vim.o.hlsearch = false

vim.o.undofile = true

vim.o.breakindent = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.termguicolors = true

vim.o.colorcolumn = "80"
vim.o.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 6, cterm = { underline = true }, underline = true })

vim.o.scrolloff = 8
