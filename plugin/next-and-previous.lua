vim.pack.add({
  { src = "https://github.com/liangxianzhe/nap.nvim", commit = "925921b" },
})

require("nap").setup({
  next_prefix = ",",
  prev_prefix = ",",
  next_repeat = "<c-n>",
  prev_repeat = "<c-p>",
})

require("nap").operator("h", {
  next = {
    command = function()
      require("gitsigns").next_hunk({ preview = false, wrap = true })
    end,
    desc = "Next diff",
  },
  prev = {
    command = function()
      require("gitsigns").prev_hunk({ preview = false, wrap = true })
    end,
    desc = "Prev diff",
  },
  mode = { "n", "v", "o" },
})
