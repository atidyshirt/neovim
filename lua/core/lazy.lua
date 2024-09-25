local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "core.resources.defaults.core" },
    { import = "core.resources.defaults.lsp" },
    { import = "core.resources.defaults.extras" },
    { import = "core.resources.ui" },
    { import = "core.resources.extensions" },
  },
  concurrency = 10,
  defaults = {
    lazy = false,
    version = "*",
  },
  install = { colorscheme = { "gruvbox-material" } },
  checker = { enabled = false, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.cmd('colorscheme gruvbox-material')
