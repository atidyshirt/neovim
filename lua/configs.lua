vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
vim.opt.winborder = "double"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10
vim.opt.shortmess:append("c")
vim.opt.fileencoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.timeoutlen = 400
vim.opt.updatetime = 500
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.wrap = false
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

if vim.env.TERM and vim.env.TERM:find('256color') then
  vim.opt.termguicolors = true
else
  vim.opt.termguicolors = false
end
