local M = {}

---@param client vim.lsp.Client
---@param buffer integer
M.attach = function(client, buffer)
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  if client.name == "pylsp" then
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, buffer)
  end
end

return M
