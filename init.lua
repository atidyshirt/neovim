require "core.options"
require "core.lazy"

local global_settings = {
  nerd_font_enabled = true,
  ai_integration_enabled = false,
}

for k, v in pairs(global_settings) do
  vim.g[k] = v
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "core.autocmds"
    require "core.keymaps"
  end,
})

