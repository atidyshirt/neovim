return {
  {
    enabled = true,
    "pmizio/typescript-tools.nvim",
    event = "BufEnter",
    cond = not vim.g.vscode,

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
          importModuleSpecifierPreference = "non-relative",
          providePrefixAndSuffixTextForRename = false,
        },
        tsserver_plugins = { "typescript-plugin-css-modules" },
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
      },
    },
  },

  -- Disabled -- trying typescript tools
  -- {
  --   enabled = false,
  --   "yioneko/nvim-vtsls",
  --   opts = {
  --     settings = {
  --       tsserver_file_preferences = {
  --         importModuleSpecifierPreference = 'project-relative'
  --       }
  --     }
  --   },
  --   config = function(_, opts)
  --     require("vtsls").config(opts)
  --   end,
  -- },
}
