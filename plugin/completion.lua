local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/zbirenbaum/copilot.lua" },
    { src = "https://github.com/zbirenbaum/copilot-cmp" },
  },
  trigger = { "InsertEnter" },
  setup = function()
    vim.opt.completeopt = { "menu", "menuone", "noinsert" }
    vim.opt.shortmess:append("c")

    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
    require("copilot_cmp").setup()

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = "menu,menuone,noinsert",
      },

      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<C-k>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<C-e>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.abort()
          else
            fallback()
          end
        end),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      }),

      sources = cmp.config.sources({
        { name = "copilot",  group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "luasnip",  group_index = 2 },
        { name = "path",     group_index = 2 },
        { name = "buffer",   group_index = 2 },
      }),

      window = {
        documentation = cmp.config.window.bordered(),
      },

      formatting = {
        fields = { "abbr", "menu", "kind" },
        format = function(entry, vim_item)
          if entry.source.name == "copilot" then
            vim_item.kind = "   Copilot"
            vim_item.kind_hl_group = "CmpItemKindCopilot"
          end
          return vim_item
        end,
      },
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    vim.lsp.config("*", { capabilities })
  end,
})
