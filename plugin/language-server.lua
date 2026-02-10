local lazyload = require("utils.lazyload")
local lsp_map = require("modules.lsp_mapping")

vim.diagnostic.config({ signs = true })
vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "CodeLens Action" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>lf", function()
  require("conform").format({ async = true })
end, { desc = "Format" })

lazyload({
  packs = {
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/b0o/SchemaStore.nvim" },
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/cwrau/yaml-schema-detect.nvim" },
    { src = "https://github.com/qvalentin/helm-ls.nvim" }
  },

  trigger = "FileType",
  pattern = "*",

  setup = function()
    vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    require("mason").setup({
      ensure_installed = { "yamlfmt" },
    })

    local servers = lsp_map.get_servers()
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    local servers2 = lsp_map.get_servers()

    vim.lsp.enable(servers2)

    local fmt = lsp_map.get_formatters_by_ft()
    require("conform").setup({
      formatters_by_ft = fmt,
    })

    require("lazydev").setup({
      library = {
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/busted/library" },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    })

    -- Helm LS integration
    pcall(require, "helm-ls")
    local ok, helm_ls = pcall(require, "helm-ls")
    if ok then helm_ls.setup({}) end
  end,
})
