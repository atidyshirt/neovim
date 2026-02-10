---@class LspMappingEntry
---@field filetype string|string[]
---@field language_server? string
---@field formatter? any
---@field linter? string|string[]

local M = {}

M.mappings = {
    { filetype = "lua", language_server = "lua_ls", formatter = { "stylua" }, treesitter = "lua" },
    { filetype = "go", language_server = "gopls", treesitter = "go" },
    {
        language_server = "tsgo",
        filetype = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        formatter = { "prettierd", "prettier", stop_after_first = true },
        linter = "oxlint",
        treesitter = { "javascript", "typescript", "tsx" },
    },
    {
        language_server = "yamlls",
        filetype = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
        formatter = { "prettierd", "prettier", stop_after_first = true },
        treesitter = "yaml",
    },
    {
        language_server = "terraformls",
        filetype = { "terraform", "terraform-vars" },
        formatter = { "terraform_fmt" },
        treesitter = { "terraform", "hcl" },
    },
    {
        language_server = "helm_ls",
        filetype = { "helm", "gotmpl", "tmpl", "tpl" },
        treesitter = { "gotmpl", "helm" },
    },
    { filetype = "bash", language_server = "bashls", treesitter = "bash" },
    {
        language_server = "pyright",
        filetype = "python",
        formatter = { "isort", "black" },
        treesitter = "python",
    },
    {
        language_server = "rust_analyzer",
        filetype = "rust",
        formatter = { "rustfmt", lsp_format = "fallback" },
        treesitter = "rust",
    },
    { filetype = "tex", language_server = "texlab" },
    {
        filetype = "json",
        formatter = { "prettierd", "prettier", stop_after_first = true },
        linter = "jsonlint",
        treesitter = "json",
    },
    {
        language_server = "cssls",
        filetype = { "css", "scss" },
        formatter = { "prettierd", "prettier", stop_after_first = true },
        linter = "stylelint",
        treesitter = { "css", "scss" },
    },
    {
        language_server = "html",
        filetype = "html",
        formatter = { "prettierd", "prettier", stop_after_first = true },
    },
    { language_server = "copilot" },
}

local function each_ft(entry, cb)
    if type(entry.filetype) == "table" then
        for _, ft in ipairs(entry.filetype) do
            cb(ft, entry)
        end
    else
        cb(entry.filetype, entry)
    end
end

function M.get_linters_by_ft()
    local t = {}
    for _, e in ipairs(M.mappings) do
        if e.linter then
            each_ft(e, function(ft)
                t[ft] = type(e.linter) == "table" and e.linter or { e.linter }
            end)
        end
    end
    return t
end

function M.get_formatters_by_ft()
    local t = {}
    for _, e in ipairs(M.mappings) do
        if e.formatter then
            each_ft(e, function(ft)
                t[ft] = e.formatter
            end)
        end
    end
    return t
end

function M.get_servers()
    local set, out = {}, {}
    for _, e in ipairs(M.mappings) do
        local s = e.language_server
        if s and not set[s] then
            set[s] = true
            table.insert(out, s)
        end
    end
    return out
end

function M.get_treesitter_parsers()
    local set, out = {}, {}
    for _, e in ipairs(M.mappings) do
        local t = e.treesitter
        if t then
            if type(t) == "table" then
                for _, p in ipairs(t) do
                    if not set[p] then set[p] = true; table.insert(out, p) end
                end
            else
                if not set[t] then set[t] = true; table.insert(out, t) end
            end
        end
    end
    return out
end

return M
