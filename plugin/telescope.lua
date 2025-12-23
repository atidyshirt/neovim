vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", opt = true },
  { src = "https://github.com/atidyshirt/neoscopes" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim" },
})

require('telescope').load_extension('live_grep_args')

---@diagnostic disable: missing-fields
require("neoscopes").setup({
  enable_scopes_from_npm = true,
  scopes = {
    { name = "root", dirs = {} },
  },
})

local scopes = require "neoscopes"

if vim.fn.filereadable(vim.fn.stdpath "config" .. "/lua/scopes.lua") == 1 then
  for _, scope in ipairs(require "scopes") do
    scopes.add(scope)
  end
end

scopes.set_current('root')

vim.keymap.set("n", "<leader>ws", function()
  require("neoscopes").select()
end, { desc = "Select scope" })

local function get_search_dirs()
  if scopes.get_current_scope() == "root" then
    return nil
  end
  return scopes.get_current_paths()
end

_G.neoscopes_find_files = function()
  require("telescope.builtin").find_files {
    search_dirs = get_search_dirs(),
  }
end

_G.neoscopes_live_grep = function()
  require("telescope").extensions.live_grep_args.live_grep_args {
    search_dirs = get_search_dirs(),
  }
end

_G.neoscopes_live_grep_current_word = function()
  require("telescope").extensions.live_grep_args.live_grep_args {
    search_dirs = get_search_dirs(),
    default_text = vim.fn.expand("<cword>")
  }
end

vim.keymap.set("n", "<leader>fs", "<Cmd>lua neoscopes_live_grep_current_word()<CR>", { desc = "Live grep - current word (scoped)" })
vim.keymap.set("n", "<leader>ff", "<Cmd>lua neoscopes_find_files()<CR>", { desc = "Find files (scoped)" })
vim.keymap.set("n", "<leader>fw", "<Cmd>lua neoscopes_live_grep()<CR>", { desc = "Live grep (scoped)" })
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Go to references" })
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to implementations" })
