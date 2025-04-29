local M = {}

---@param _ vim.lsp.Client
---@param buffer integer
M.attach = function(_, buffer)
  local opts = { noremap = true, silent = true }
  local map = vim.api.nvim_buf_set_keymap
  map(buffer, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  map(buffer, "n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  map(buffer, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  map(buffer, "n", "]d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
  map(buffer, "n", "[d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
  map(buffer, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  map(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map(buffer, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map(buffer, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
end

return M
