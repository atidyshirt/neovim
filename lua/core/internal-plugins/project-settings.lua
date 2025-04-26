---@class ProjectSettingsConfig
---@field settings_file? string
---@field on_error? fun(err: string)
---@field default_settings? table<string, any>

---@class ProjectSettingsModule
---@field setup fun(opts: ProjectSettingsConfig?)
---@field apply_settings fun()
local M = {}
local default_settings = {}

---@type ProjectSettingsConfig
local config = {
  settings_file = '.nvim-settings.json',
  on_error = function(err) vim.notify('Project Settings: ' .. err, vim.log.levels.ERROR) end
}

---[project-settings.setup]: Setup the plugin configuration
---
---project-settings declares its settings on `vim.g` so it must be called before any other plugin that uses `vim.g`
---@param opts? ProjectSettingsConfig
function M.setup(opts)
  if opts then
    config = vim.tbl_deep_extend('force', config, opts)
    default_settings = vim.tbl_deep_extend('force', default_settings, opts.default_settings or {})
  end
end

---@return table<string, any>
local function load_settings()
  local json_path = vim.fn.findfile(config.settings_file, '.;')
  if json_path == '' then return default_settings end

  local ok, json = pcall(vim.fn.readfile, json_path)
  if not ok then
    return default_settings
  end

  local json_str = table.concat(json, '')
  local ok, project_settings = pcall(vim.json.decode, json_str)
  if not ok then
    config.on_error('Invalid JSON in: ' .. json_path)
    return default_settings
  end

  return vim.tbl_deep_extend('force', default_settings, project_settings)
end

function M.apply_settings()
  local settings = load_settings()
  for k, v in pairs(settings) do
    vim.g[k] = v
  end

  vim.schedule(function()
    local proj_file = vim.fn.findfile(config.settings_file, '.;')
    if proj_file ~= '' then
      vim.notify('Loaded project settings from: ' .. proj_file, vim.log.levels.INFO)
    end
  end)
end

return M
