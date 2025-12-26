vim.pack.add({
  { src = "https://github.com/liangxianzhe/nap.nvim" },
})

require("nap").setup({
  -- Note: overriding ,; here because I never use them in favour of using highlights on 'f,t' commands
  next_prefix = ",",
  prev_prefix = ";",
  next_repeat = "<c-n>",
  prev_repeat = "<c-p>",
})

require("nap").map('h', require("nap").gitsigns())
