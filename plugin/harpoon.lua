vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/atidyshirt/harpoon", version = "harpoon2" },
  { src = "https://github.com/atidyshirt/harpoon-tmux" },
})

vim.schedule(function()
  local harpoon = require("harpoon")
  local harpoon_tmux = require("harpoon-tmux")

  harpoon:setup({
    ['tmux'] = harpoon_tmux.build_list(),
  })

  -- File harpoon keymaps
  vim.keymap.set("n", "ga", function() harpoon:list():add() end)
  vim.keymap.set("n", "gm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  vim.keymap.set("n", "gj", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "gk", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "gl", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "g;", function() harpoon:list():select(4) end)

  -- Tmux terminal keymaps
  vim.keymap.set("n", "gt", function() harpoon_tmux.go_to_terminal(1) end)
  vim.keymap.set("n", "gy", function() harpoon_tmux.go_to_terminal(2) end)

  -- Tmux harpoon keymaps
  vim.keymap.set("n", "<leader><space>m", function() harpoon.ui:toggle_quick_menu(harpoon:list('tmux')) end)
  vim.keymap.set("n", "<leader><space>j", function() harpoon:list('tmux'):select(1) end)
  vim.keymap.set("n", "<leader><space>k", function() harpoon:list('tmux'):select(2) end)
  vim.keymap.set("n", "<leader><space>l", function() harpoon:list('tmux'):select(3) end)
  vim.keymap.set("n", "<leader><space>;", function() harpoon:list('tmux'):select(4) end)
end)
