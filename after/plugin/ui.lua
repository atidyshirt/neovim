local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/atidyshirt/gruvbox-baby" },
    { src = "https://github.com/utilyre/barbecue.nvim" },
    { src = "https://github.com/SmiteshP/nvim-navic" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/Bekaboo/deadcolumn.nvim" },
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
    { src = "https://github.com/folke/snacks.nvim" },
  },
  trigger = { "UIEnter" },
  once = true,
  setup = function()
    require("barbecue").setup({
      attach_navic = false,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
    })

    require("deadcolumn").setup({
      scope = "line",
      modes = { "i", "ic", "ix", "R", "Rc", "Rx", "Rv", "Rvc", "Rvx" },
      blending = {
        threshold = 0.5,
        colorcode = "#ea6962",
        hlgroup = { "Normal", "background" },
      },
      warning = {
        alpha = 0.4,
        offset = 0,
        colorcode = "#ea6962",
        hlgroup = { "Error", "background" },
      },
      extra = { follow_tw = nil },
    })

    pcall(function()
      require("nvim-highlight-colors").setup()
    end)

    require("snacks").setup({
      input = { enabled = true },
      notifier = {
        enabled = true,
        style = "minimal",
        timeout = 10000,
        top_down = false,
        margin = { bottom = 1 },
        padding = true,
      },
      statuscolumn = { enabled = true },
      indent = { enabled = true },
      picker = {
        enabled = true,
        win = { input = { keys = {} } },
      },
    })
  end,
})

vim.cmd.colorscheme("gruvbox-baby")
