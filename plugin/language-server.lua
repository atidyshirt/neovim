local lazyload = require("utils.lazyload")

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
  },

  trigger = { "BufReadPost", "BufNewFile" },

  setup = function()
    vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    require("mason").setup({
      ensure_installed = { "yamlfmt" },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "bashls", "gopls", "lua_ls", "texlab", "tsgo", "rust_analyzer",
        "yamlls", "pyright", "cssls", "html", "copilot", "tofu_ls",
      },
      automatic_installation = true,
    })

    vim.lsp.enable({
      "bashls", "gopls", "lua_ls", "texlab", "ts_ls", "rust_analyzer",
      "yamlls", "pyright", "cssls", "html", "tofu_ls", "copilot",
    })

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        terraform = { "terraform_fmt" },
        markdown = { "mdformat" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
      },
    })

    require("lazydev").setup({
      library = {
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/busted/library" },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    })
  end,
})
