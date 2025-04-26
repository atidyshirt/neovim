local util = require "core.util"

local globals = {
  nerd_font_enabled = util.settings_env("NERD_FONT_ENABLED", true),
  ai_integration_enabled = util.settings_env("AI_INTEGRATION_ENABLED", true),
  loaded_netrw = 1,
  loaded_netrwPlugin = 1,
  mapleader = " ",
  maplocalleader = ",",
}

for k, v in pairs(globals) do
  vim.g[k] = v
end

return globals
