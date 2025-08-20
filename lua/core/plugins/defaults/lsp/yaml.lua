local util = require "core.util"

vim.api.nvim_create_user_command("DiagnosticsWithSource", function()
  local diagnostics = vim.diagnostic.get(0)  -- get diagnostics in current buffer
  for _, diag in ipairs(diagnostics) do
    print(string.format("Line %d: %s (Source: %s)", diag.lnum + 1, diag.message, diag.source or "unknown"))
  end
end, {})

return {
  {
    'diogo464/kubernetes.nvim',
    opts = {
      schema_strict = true,
      schema_generate_always = true,
      patch = true,
      yamlls_root = function()
        return vim.fs.joinpath(vim.fn.stdpath("data"), "/mason/packages/yaml-language-server/")
      end
    }
  },
  {
    "cwrau/yaml-schema-detect.nvim",
    ---@module "yaml-schema-detect"
    ---@type YamlSchemaDetectOptions
    opts = {},
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "yaml" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              {
                [require('kubernetes').yamlls_schema()] = "*.yaml",
                [require('kubernetes').yamlls_schema()] = require('kubernetes').yamlls_filetypes()
              },
              require("schemastore").yaml.schemas()
            )
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
              validate = true,
              schemaStore = {
                enable = false,
                url = "",
              },
            },
          },
        },
      },
      setup = {
        yamlls = function()
          if vim.fn.has("nvim-0.10") == 0 then
            util.on_attach(function(client, _)
              client.server_capabilities.documentFormattingProvider = true
            end, "yamlls")
          end
        end,
      },
    },
  }
}
