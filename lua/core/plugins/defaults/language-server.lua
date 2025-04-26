return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
      },
    },
    keys = {
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", mode = {"n", "v"}, desc = "Code Action" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      {
        "<leader>lf",
        function()
          vim.lsp.buf.format({
            filter = function(client)
              local exclude_servers = { "lua_ls", "pyright", "pylsp" }
              return not vim.tbl_contains(exclude_servers, client.name)
            end,
          })
        end,
        desc = "Format",
      }
    },
    opts = {
      servers = {
        cssls = {},
        html = {},
        lua_ls = {},
      },
      attach_handlers = {},
    },
    config = function(_, opts)
      local Util = require("core.util")
      local lsp_setup = require("config.lsp.lsp-setup-service")

      Util.on_attach(function(client, buffer)
        require("config.lsp.navic").attach(client, buffer)
        require("config.lsp.keymaps").attach(client, buffer)
        require("config.lsp.inlayhints").attach(client, buffer)
        require("config.lsp.gitsigns").attach(client, buffer)
      end)

      lsp_setup.attach_diagnostics()
      lsp_setup.attach_lsp_handlers(opts)
    end
  },
}
