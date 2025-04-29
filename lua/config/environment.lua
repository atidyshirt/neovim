local util = require "core.util"

---@param str string
---@return boolean
local function str_to_bool(str)
    if str == nil then
        return false
    end
    return string.lower(str) == 'true'
end

return {
  nerd_font_enabled = str_to_bool(util.settings_env("NERD_FONT_ENABLED", 'true')),
  ai_integration_enabled = str_to_bool(util.settings_env("AI_INTEGRATION_ENABLED", 'true')),
}
