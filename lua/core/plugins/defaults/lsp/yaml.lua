---@diagnostic disable: param-type-mismatch
vim.api.nvim_create_user_command("DiagnosticsWithSource", function()
  local diagnostics = vim.diagnostic.get(0) -- get diagnostics in current buffer
  for _, diag in ipairs(diagnostics) do
    print(string.format("Line %d: %s (Source: %s)", diag.lnum + 1, diag.message, diag.source or "unknown"))
  end
end, {})

return {
  {
    "cwrau/yaml-schema-detect.nvim",
    ---@module "yaml-schema-detect"
    ---@type YamlSchemaDetectOptions
    opts = {
      keymap = {
        refresh = "<leader>yr",
        cleanup = "<leader>yc",
        info = "<leader>yi",
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    ft = { "yaml" },
  }
}
