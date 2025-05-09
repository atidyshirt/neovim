local M = {}

M.filetypes = {
  "lua",
  "c",
  "cpp",
  "python",
  "zig",
  "bash",
  "javascript",
  "typescript",
}

M.augroup = function(name)
  return vim.api.nvim_create_augroup("ats_" .. name, { clear = true })
end

--- @param on_attach fun(client, buffer)
M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.get_highlight_value = function(group)
  local found, hl = pcall(vim.api.nvim_get_hl_by_name, group, true)
  if not found then
    return {}
  end
  local hl_config = {}
  for key, value in pairs(hl) do
    _, hl_config[key] = pcall(string.format, "#%02x", value)
  end
  return hl_config
end

M.capabilities = function(ext)
  return vim.tbl_deep_extend(
    "force",
    {},
    ext or {},
    { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
  )
end

---@param variable string The environment variable name to check
---@param default string
---@return string
M.settings_env = function(variable, default)
  local value = vim.env[variable]
  if value == nil then return default end
  return value
end

return M
