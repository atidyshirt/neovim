local Icons = require('core.icons')
vim.g.diagnostics_enabled = true

local diagnostics = {
  off = {
      underline = true,
      virtual_text = false,
      signs = false,
      update_in_insert = false,
    },
    on = {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = Icons.diagnostics.error,
        [vim.diagnostic.severity.WARN] = Icons.diagnostics.warn,
        [vim.diagnostic.severity.HINT] = Icons.diagnostics.hint,
        [vim.diagnostic.severity.INFO] = Icons.diagnostics.info,
      },
    },
    virtual_lines = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "●",
    },
  },
}

vim.api.nvim_create_user_command("ToggleDiagnostic", function()
  if vim.g.diagnostics_enabled then
    vim.diagnostic.config(diagnostics["off"])
    vim.g.diagnostics_enabled = false
  else
    vim.diagnostic.config(diagnostics["on"])
    vim.g.diagnostics_enabled = true
  end
end, { nargs = 0 })

return diagnostics
