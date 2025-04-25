require "core.options"

local global_settings = {
  nerd_font_enabled = true,
  ai_integration_enabled = false,
}

for k, v in pairs(global_settings) do
  vim.g[k] = v
end

require "core.lazy"

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require "core.autocmds"
    require "core.keymaps"
  end,
})

