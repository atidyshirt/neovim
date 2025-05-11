local util = require "core.util"

---@param str string
---@return boolean
local function str_to_bool(str)
    if str == nil then
        return false
    end
    return string.lower(str) == 'true'
end

local environment = {
  nerd_font_enabled = str_to_bool(util.settings_env("NERD_FONT_ENABLED", 'true')),
  supermaven_enabled = str_to_bool(util.settings_env("SUPERMAVEN_ENABLED", 'true')),
  copilot_enabled = str_to_bool(util.settings_env("COPILOT_ENABLED", 'false')),
}

for k, v in pairs(environment) do
  vim.env[k] = v
end
