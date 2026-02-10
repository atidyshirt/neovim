local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

-- Filetype detection for Helm charts and Go templates
vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
    gotmpl = "gotmpl",
    tpl = "helm",
  },
  pattern = {
    [".*/charts/.*%.ya?ml"] = "helm",
    [".*/Charts/.*%.ya?ml"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
  },
})
