vim.pack.add({
  { src = "https://github.com/folke/sidekick.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/fang2hou/blink-copilot" },
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  once = true,
  callback = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })

    require("sidekick").setup({
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    })

    vim.keymap.set({ "n", "x" }, "<leader>ai", function()
      require("sidekick.cli").toggle()
    end, { desc = "Sidekick Toggle" })

    vim.keymap.set({ "n" }, "<leader>as", function()
      require("sidekick.cli").select()
    end, { desc = "Select CLI" })

    vim.keymap.set({ "x" }, "<leader>av", function()
      require("sidekick.cli").send({ msg = "{selection}" })
    end, { desc = "Send Visual Selection" })

    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-l>'] = { 'accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
        ["<Tab>"] = {
          "snippet_forward",
          'select_next',
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          "fallback",
        },
        ['<C-j>'] = { 'show', 'select_next', 'fallback_to_mappings' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<C-k>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
        ['<C-h>'] = { 'show_documentation', 'hide_documentation' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
      completion = {
        documentation = { auto_show = false },
      },
      sources = {
        default = {
          "copilot",
          "lsp",
          "snippets",
          "path",
          "buffer"
        },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
  end,
})
