vim.loader.enable()
vim.o.packlockfile = vim.fn.stdpath("config") .. "/nvim-pack-lock.json"

require 'disabled'
require 'configs'
require 'keymaps'
require 'autocmds'
