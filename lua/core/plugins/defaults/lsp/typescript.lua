return {
  {
    enabled = true,
    "pmizio/typescript-tools.nvim",
    event = "BufEnter",
    keys = {
      {
        "<leader>li",
        "<cmd>TSToolsAddMissingImports sync<CR><cmd>TSToolsRemoveUnusedImports sync<CR>",
        desc = "Fix imports",
      },
      {
        "<leader>lf",
        "<cmd>TSToolsFixAll sync<CR>",
        desc = "Fix all problems",
      },
    },

    opts = {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
      settings = {
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "relative",
          providePrefixAndSuffixTextForRename = false,
        },
        tsserver_plugins = { "typescript-plugin-css-modules" },
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
      },
    },
  },
}
