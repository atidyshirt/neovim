---@type vim.lsp.ClientConfig
if not package.loaded["schema-companion"] then
  vim.cmd.packadd("schema-companion.nvim")
  require("schema-companion").setup({ log_level = vim.log.levels.WARN })
end

return require("schema-companion").setup_client(
  require("schema-companion").adapters.yamlls.setup({
    sources = {
      require("schema-companion").sources.matchers.kubernetes.setup({ version = "master" }),
      require("schema-companion").sources.lsp.setup(),
      require("schema-companion").sources.schemas.setup({
        {
          name = "Kubernetes master",
          uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
        },
      }),
    },
  }),
  {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = {
      "yaml",
      "yaml.docker-compose",
      "yaml.gitlab",
      "yaml.helm-values",
    },
    root_markers = { ".git" },
    settings = {
      flags = {
        debounce_text_changes = 50,
      },
      redhat = { telemetry = { enabled = false } },
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        format = { enable = false },
        editor = {
          formatOnType = false,
        },
        schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
        schemaDownload = { enable = true },
        schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
          -- Kubernetes
          ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json"] = { "{manifests,k8s,kubernetes}/**/*.{yml,yaml}" },
          ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = { "*argocd*.{yml,yaml}" },
          ["http://json.schemastore.org/kustomization"] = { "kustomization.ya?ml" },
          ["http://json.schemastore.org/chart"] = { "Chart.ya?ml" },

          -- Github
          ["https://json.schemastore.org/github-workflow.json"] = { ".github/workflows/*.ya?ml" },
          ["https://json.schemastore.org/github-action.json"] = { ".github/action.ya?ml", ".github/*/action.ya?ml" },

          -- Ansible
          ["https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-playbook.json"] = {
            "deploy.yml",
            "provision.yml",
          },

          -- Other
          ["https://taskfile.dev/schema.json"] = { "Taskfile.*.ya?ml", },
          ["http://json.schemastore.org/prettierrc"] = { ".prettierrc.ya?ml" },
        }),
      },
    },
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = true
    end,
  }
)
