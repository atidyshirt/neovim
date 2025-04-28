local util = require "core.util"

return {
  nerd_font_enabled = util.settings_env("NERD_FONT_ENABLED", true),
  ai_integration_enabled = util.settings_env("AI_INTEGRATION_ENABLED", true),
}
