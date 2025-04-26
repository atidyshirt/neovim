local M = {}

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
---@param default boolean The fallback value if variable doesn't exist
---@return boolean # Parsed boolean value (true for "1"/"true", false otherwise)
M.settings_env = function(variable, default)
  local value = vim.env[var_name]
  if value == nil then return default end
  return value == "1" or value:lower() == "true"
end

return M
