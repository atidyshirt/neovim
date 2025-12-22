return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab', 'yaml.helm-values' },
    root_markers = { '.git' },
    settings = {
        yaml = {
            keyOrdering = false,
            format = { enable = true, singleQuote = false, bracketSpacing = true },
            validate = true,
            hover = true,
            completion = true,
            schemas = {
                kubernetes = { "k8s-*.{yml,yaml}", "manifests/**/*.{yml,yaml}" },
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                ["http://json.schemastore.org/github-action"] = ".github/**/action.{yml,yaml}",
                ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
            },
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/json",
            },
            redhat = { telemetry = { enabled = false } },
            schemaDownload = { enable = true },
        },
    },
    on_init = function(client)
        --- https://github.com/neovim/nvim-lspconfig/pull/4016
        --- Since formatting is disabled by default if you check `client:supports_method('textDocument/formatting')`
        --- during `LspAttach` it will return `false`. This hack sets the capability to `true` to facilitate
        --- autocmd's which check this capability
        client.server_capabilities.documentFormattingProvider = true
    end,
}
