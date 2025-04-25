local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "core.plugins.defaults.core" },
    { import = "core.plugins.defaults.lsp" },
    { import = "core.plugins.defaults.extras" },
    { import = "core.plugins.ui" },
    { import = "core.plugins.extensions" },
  },
  concurrency = 10,
  defaults = {
    lazy = false,
    version = "*",
  },
  install = { colorscheme = { "gruvbox-baby" } },
  checker = { enabled = false, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "matchparen",
      },
    },
  },
})

vim.cmd('colorscheme gruvbox-baby')
