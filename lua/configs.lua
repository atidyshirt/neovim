local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 0,
  confirm = true,
  completeopt = { "menu", "menuone", "noselect" },
  conceallevel = 0,
  fileencoding = "utf-8",
  incsearch = true,
  hlsearch = true,
  inccommand = "nosplit",
  ignorecase = true,
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  mouse = "a",
  pumheight = 10,
  showmode = false,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  timeoutlen = 400,
  undofile = true,
  updatetime = 500,
  writebackup = false,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  cursorline = true,
  number = true,
  relativenumber = true,
  numberwidth = 4,
  signcolumn = "yes",
  wrap = false,
  laststatus = 3,
  background = "dark",
  selection = "exclusive",
  virtualedit = "onemore",
  showcmd = false,
  title = true,
  titlestring = "%<%F%=%l/%L - nvim",
  linespace = 8,
  mousemoveevent = true,
  syntax = "off",
  spelllang = { "en" },
  colorcolumn = "120",
  winborder = "double",
  foldlevelstart = 99,
  foldlevel = 99,
  foldenable = true,
  foldcolumn = "1",
  fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
  },

  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
}
vim.opt.shortmess:append("c")
vim.opt.viewoptions:remove "curdir"

vim.opt.list = true

if vim.env.TERM:find('256color') then
  options.termguicolors = true
else
  options.termguicolors = false
end

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.g.copilot_no_tab_map = true
vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"

-- require('vim._extui').enable({})
