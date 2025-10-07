local util = require("core.util")

local environment = {
  nerd_font_enabled = util.str_to_bool(util.settings_env("NERD_FONT_ENABLED", "true")),
  copilot_enabled = util.str_to_bool(util.settings_env("COPILOT_ENABLED", "true")),
  auto_dark_mode_enabled = util.str_to_bool(util.settings_env("AUTO_DARK_MODE_ENABLED", "true")),
}

for k, v in pairs(environment) do
  vim.env[k] = v
end
