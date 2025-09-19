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
    ---@type table
    opts = {},
    dependencies = {
      "neovim/nvim-lspconfig",
      "b0o/SchemaStore.nvim",
      "diogo464/kubernetes.nvim",
    },
    ft = { "yaml" },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },
  {
    "diogo464/kubernetes.nvim",
    ft = { "yaml" },
    enabled = function()
      -- Only enable if kubectl is available and cluster is accessible
      local handle = io.popen("kubectl cluster-info --request-timeout=2s 2>/dev/null")
      if handle then
        local result = handle:read("*a")
        handle:close()
        return result and result ~= "" and not result:match("refused")
      end
      return false
    end,
    config = function()
      -- Wrap kubernetes plugin setup with error handling
      local ok, kubernetes = pcall(require, "kubernetes")
      if ok and kubernetes then
        -- Set up error handling for kubernetes operations
        local original_yamlls_schema = kubernetes.yamlls_schema
        local original_yamlls_filetypes = kubernetes.yamlls_filetypes
        kubernetes.yamlls_schema = function()
          local success, result = pcall(original_yamlls_schema)
          if success then
            vim.notify(
              "Schema has been applied: " .. tostring(result),
              vim.log.levels.INFO,
              { title = "Kubernetes.nvim" }
            )
            return result
          else
            vim.notify(
              "Failed to get Kubernetes schema: " .. tostring(result),
              vim.log.levels.ERROR,
              { title = "Kubernetes.nvim" }
            )
            return nil
          end
        end

        kubernetes.yamlls_filetypes = function()
          local success, result = pcall(original_yamlls_filetypes)
          if success then
            return result
          else
            vim.notify(
              "Failed to get Kubernetes filetypes: " .. tostring(result),
              vim.log.levels.ERROR,
              { title = "Kubernetes.nvim" }
            )
            return {}
          end
        end
      end
    end,
    opts = {},
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
            -- Combine Kubernetes schemas with SchemaStore schemas
            local schemas = {}

            -- Add Kubernetes schemas if available and cluster is accessible
            local ok, k8s = pcall(require, "kubernetes")
            if ok and k8s then
              local success, result = pcall(function()
                return k8s.yamlls_schema(), k8s.yamlls_filetypes()
              end)
              if success then
                schemas[result] = k8s.yamlls_filetypes()
                vim.notify(
                  "Kubernetes cluster schemas loaded successfully",
                  vim.log.levels.INFO,
                  { title = "YAML LSP" }
                )
              else
                vim.notify(
                  "Failed to load Kubernetes cluster schemas, using fallback",
                  vim.log.levels.WARN,
                  { title = "YAML LSP" }
                )
              end
            else
              vim.notify(
                "Kubernetes plugin not available, using fallback schemas",
                vim.log.levels.INFO,
                { title = "YAML LSP" }
              )
            end

            -- Add SchemaStore schemas
            if pcall(require, "schemastore") then
              schemas = vim.tbl_deep_extend("force", schemas, require("schemastore").yaml.schemas())
            end

            -- Add fallback Kubernetes schemas if cluster is not available
            if not ok then
              schemas["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone-strict/all.json"] =
                {
                  "k8s-*.yaml",
                  "k8s-*.yml",
                  "kubernetes-*.yaml",
                  "kubernetes-*.yml",
                  "**/k8s/**/*.yaml",
                  "**/k8s/**/*.yml",
                  "**/kubernetes/**/*.yaml",
                  "**/kubernetes/**/*.yml",
                  "deployment.yaml",
                  "service.yaml",
                  "configmap.yaml",
                  "secret.yaml",
                  "ingress.yaml",
                }
              vim.notify(
                "Using fallback Kubernetes schemas (cluster not available)",
                vim.log.levels.INFO,
                { title = "YAML LSP" }
              )
            end

            new_config.settings.yaml.schemas =
              vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, schemas)
          end,
          on_attach = function(client, bufnr)
            -- Disable formatting for Kubernetes files to avoid conflicts
            local filename = vim.api.nvim_buf_get_name(bufnr)
            if
              filename:match("k8s")
              or filename:match("kubernetes")
              or filename:match("deployment")
              or filename:match("service")
            then
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end

            -- Configure yamlls to be less strict about indentation
            -- This prevents red errors on indentless arrays (Kubernetes style)
            if client.name == "yamlls" then
              -- Disable strict indentation validation that conflicts with yamlfmt
              client.config.settings.yaml.validate = true
              client.config.settings.yaml.format = false
              client.config.settings.yaml.hover = true
              client.config.settings.yaml.completion = true
              client.config.settings.yaml.keyOrdering = false
              client.config.settings.yaml.customTags = {}
              
              -- Fix blink.cmp extmark issues with yamlls
              client.server_capabilities.completionProvider = {
                resolveProvider = false,
                triggerCharacters = { ":", " ", "-", "*", "?", "!", "[", "]", "{", "}", "(", ")" },
              }
            end
          end,
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              format = {
                enable = false, -- Disable yamlls formatting, use yamlfmt instead
              },
              validate = true,
              hover = true,
              completion = true,
              keyOrdering = false,
              -- Configure yamlls to accept indentless arrays (Kubernetes style)
              customTags = {},
            },
          },
        },
      },
    },
  },
}
