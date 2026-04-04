---@type vim.lsp.Config
return {
  cmd = { "tsgo", "--lsp", "--stdio" },
  settings = {
    typescript = {
      preferences = {
        quotePreference = "single",
        importModuleSpecifierPreference = "relative",
      },
    },
  },

  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
    "tsconfig.base.json",
  },
}
