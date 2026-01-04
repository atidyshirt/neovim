local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/atidyshirt/harpoon", version = "harpoon2" },
    { src = "https://github.com/atidyshirt/harpoon-tmux" },
  },
  trigger = "VimEnter",
  once = true,
  setup = function()
    if package.loaded["harpoon"] == true then
      package.loaded["harpoon"] = nil
    end

    local harpoon = require("harpoon")
    local harpoon_tmux = require("harpoon-tmux")

    harpoon:setup({ ['tmux'] = harpoon_tmux.build_list() })
  end,
  keymaps = {
    ["ga"] = function() require("harpoon"):list():add() end,
    ["gm"] = function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    ["gj"] = function() require("harpoon"):list():select(1) end,
    ["gk"] = function() require("harpoon"):list():select(2) end,
    ["gl"] = function() require("harpoon"):list():select(3) end,
    ["g;"] = function() require("harpoon"):list():select(4) end,
    ["gt"] = function() require("harpoon-tmux").go_to_terminal(1) end,
    ["gy"] = function() require("harpoon-tmux").go_to_terminal(2) end,
    ["<leader><space>m"] = function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list('tmux'))
    end,
    ["<leader><space>j"] = function() require("harpoon"):list('tmux'):select(1) end,
    ["<leader><space>k"] = function() require("harpoon"):list('tmux'):select(2) end,
    ["<leader><space>l"] = function() require("harpoon"):list('tmux'):select(3) end,
    ["<leader><space>;"] = function() require("harpoon"):list('tmux'):select(4) end,
  }
})
