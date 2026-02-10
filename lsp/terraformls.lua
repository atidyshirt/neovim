---@type vim.lsp.Config
return {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars' },
  -- Avoid '.git' so each module directory is its own root in monorepos.
  root_markers = {
    '.terraform',
    'terraform.tf',
    'main.tf',
    'variables.tf',
    'outputs.tf',
    'providers.tf',
    'backend.tf',
    'terragrunt.hcl',
  },
  settings = {},
}
