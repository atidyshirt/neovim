local M = {}

---@param client vim.lsp.Client
---@param buffer integer
M.attach = function(client, buffer)
  local status_ok, inlayhints = pcall(require, "lsp-inlayhints")
  if not status_ok then
    return
  end
  inlayhints.on_attach(client, buffer)
end

return M
