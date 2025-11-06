local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  git = {
    timeout = 300,
  },
  spec = {
    { import = "core.plugins.defaults" },
    { import = "core.plugins.defaults.lsp" },
    { import = "core.plugins.ui" },
    { import = "core.plugins.extensions" },
  },
  concurrency = 10,
  change_detection = { enabled = true, notify = false },
  defaults = {
    lazy = false,
    version = "*",
  },
  ui = {
    size = { width = 1, height = 1 },
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
