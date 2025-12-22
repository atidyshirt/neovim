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

vim.keymap.set({ "n", "t", "x" }, "<leader>at", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

vim.keymap.set({ "n" }, "<leader>as", function()
  require("sidekick.cli").select()
end, { desc = "Select CLI" })

vim.keymap.set({ "x" }, "<leader>av", function()
  require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

vim.keymap.set({ "n" }, "<leader>ai", function()
  require("sidekick.cli").toggle({ name = "copilot", focus = true })
end, { desc = "Sidekick Toggle Copilot" })

vim.keymap.set({ "n" }, "<leader>ah", function()
  local harpoon = require("harpoon")
  local items = harpoon:list().items
  local context = ""
  for _, item in ipairs(items) do
    if item.value and item.value ~= "" then
      context = context .. string.format("@%s\n", item.value)
    end
  end
  require("sidekick.cli").send({ msg = context })
end, { desc = "Send Harpoon List to Sidekick" })

