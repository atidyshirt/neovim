---@type vim.lsp.Config
return {
    cmd = { "helm_ls", "serve" },
    settings = {},
    filetypes = { "helm", "helmfile", "yaml", "yml", "gotmpl", "tmpl", "tpl" },
    root_markers = { "Chart.yaml" },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}
