local Icon = require("core.icons")

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline",
        format = Icon.noice,
      },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false, silent = true },
        signature = { enabled = false },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      messages = {
        enabled = false,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
        },
        {
          filter = {
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
