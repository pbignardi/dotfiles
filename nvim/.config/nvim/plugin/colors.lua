-- colorscheme configuration

if vim.g.vscode then
  return
end

-- install packages
vim.pack.add {
  "https://github.com/TheNiteCoder/mountaineer.vim",
}

-- set colorscheme
vim.cmd.colorscheme "mayu_lc"
