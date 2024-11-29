package.path = package.path .. ":~/.luarocks/share/lua/5.1/?/init.lua"
vim.g.mapleader = " "
vim.g.netrw_browsex_viewer = "open"
vim.g.netrw_nogx = false

vim.keymap.set('n', '<leader>rw', vim.cmd.Ex)
vim.keymap.set('i', 'jk', '<Esc>')

vim.wo.fillchars='eob: '

vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '80'
vim.opt.exrc = true
