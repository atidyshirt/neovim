local Util = require("core.util")

---@diagnostic disable: missing-fields, missing-parameter
local lsp_dependencies = {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "LazyVim",
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "${3rd}/busted/library" },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        hcl = { "packer_fmt" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
    config = true,
  },
}

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls", 
          "gopls",
          "yamlls",
          "cssls",
          "html",
          "bashls",
          "tofu_ls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    branch = "master",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = lsp_dependencies,
    keys = {
      { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", mode = { "n", "v" }, desc = "Code Action" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
      {
        "<leader>lf",
        function()
          require("conform").format({ async = true }, function() end)
        end,
        desc = "Format",
      },
    },
    opts = {
      servers = {
        -- Basic web servers
        cssls = {},
        html = {},
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              telemetry = { enable = false },
            },
          },
        },
        -- TypeScript/JavaScript (using ts_ls instead of typescript-tools)
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-node_modules" },
            },
          },
        },
        -- YAML
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = { 
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
              },
              validate = true,
              hover = true,
              completion = true,
              schemaStore = { 
                enable = false, -- Disable to avoid outdated schemas
                url = "",
              },
              schemas = {
                -- Use working Kubernetes schema
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.28.0-standalone-strict/all.json"] = {
                  "*.yaml",
                  "*.yml",
                  "k8s/**/*.yaml",
                  "k8s/**/*.yml",
                  "kubernetes/**/*.yaml",
                  "kubernetes/**/*.yml",
                },
                -- Fallback to older version if needed
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.4-standalone-strict/all.json"] = {
                  "*.yaml",
                  "*.yml",
                },
              },
              customTags = {
                "!And",
                "!If",
                "!Not",
                "!Equals",
                "!Or",
                "!FindInMap sequence",
                "!Base64",
                "!Cidr",
                "!Ref",
                "!Sub",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!Select",
                "!Split",
                "!Join sequence",
              },
              -- Additional settings for better Kubernetes support
              redhat = {
                telemetry = {
                  enabled = false,
                },
              },
              -- Enable schema suggestions
              schemaDownload = {
                enable = true,
              },
            },
          },
        },
        -- Bash
        bashls = {},
        -- Terraform
        tofu_ls = {
          cmd = { 'tofu-ls', 'serve' },
          filetypes = { 'terraform', 'terraform-vars' },
          root_markers = {'.terraform', '.git'},
          settings = {},
        },
      },
      attach_handlers = {},
    },
    config = function(_, opts)
      local lsp_setup = require("config.lsp.lsp-setup-service")

      Util.on_attach(function(client, buffer)
        require("config.lsp.navic").attach(client, buffer)
        require("config.lsp.keymaps").attach(client, buffer)
      end)

      lsp_setup.attach_diagnostics()
      lsp_setup.attach_lsp_handlers(opts)
    end,
  },
}
