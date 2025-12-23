vim.pack.add({
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt = "menu,menuone,noinsert",
    },

    performance = {
        fetching_timeout = 50,
        max_view_entries = 20,
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<C-e>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
            else
                fallback()
            end
        end),

        ["<C-j>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
    }),

    window = {
        documentation = cmp.config.window.bordered(),
    },

    formatting = {
        fields = { "abbr", "menu", "kind" },
    },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
vim.lsp.config("*", { capabilities })

vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.shortmess:append("c")
