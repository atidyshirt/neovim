vim.pack.add({
  { src = "https://github.com/folke/sidekick.nvim" },
})

require("sidekick").setup({
  cli = {
    mux = {
      backend = "tmux",
      enabled = false,
    },
  },
})

vim.keymap.set({ "n" }, "<leader>aa", function()
  require("sidekick").nes_jump_or_apply()
end, { expr = true, desc = "jump or apply suggestion" })

vim.keymap.set({ "n", "x" }, "<leader>ai", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

vim.keymap.set({ "n" }, "<leader>as", function()
  require("sidekick.cli").select()
end, { desc = "Select CLI" })

vim.keymap.set({ "x" }, "<leader>av", function()
  require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })
