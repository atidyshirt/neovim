local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

_G.toggle_quickfix = function ()
  if not vim.tbl_isempty(vim.fn.getwininfo()) and vim.bo.buftype == "quickfix" then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

-- keymap("n", "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", opts)
-- keymap("n", "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", opts)
-- keymap("n", "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", opts)
-- keymap("n", "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", opts)
keymap("n", "gs", ":0G<CR>", opts)
keymap("n", "<leader>x", ":bd!<CR>", opts)
keymap("n", "<leader>X", ":%bd!|e#<CR>", opts)
keymap("n", "<esc>", "<cmd>noh<cr><esc>", opts)
keymap("n", "<leader>q", ":lua toggle_quickfix()<CR>", { silent = true })
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("n", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- terminal mappings
-- keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Optionally, to navigate windows from terminal mode like normal mode with Ctrl + hjkl
keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

vim.keymap.set("n", "<C-f>", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes"))
end, { desc = "[/] Fuzzily search in current buffer]" })
