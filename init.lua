require "config.options"
local default_settings = require "config.globals"
local project_settings = require "core.internal-plugins.project-settings"

project_settings.setup({ default_settings })
project_settings.load_file_settings_to_env()

require "config.environment"
require "core.lazy"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "config.autocmds"
    require "config.keymaps"
  end,
})

