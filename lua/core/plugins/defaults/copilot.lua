local util = require("core.util")

return {
  {
    "folke/sidekick.nvim",
    enabled = util.str_to_bool(vim.env.copilot_enabled),
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<leader>ai",
        function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
        desc = "Sidekick Toggle Copilot",
      },
      {
        "<leader>ah",
        function()
          local harpoon = require("harpoon")
          local items = harpoon:list().items
          local context = ""
          for _, item in ipairs(items) do
            if item.value and item.value ~= "" then
              context = context .. string.format("@%s\n", item.value)
            end
          end
          require("sidekick.cli").send({ msg = context })
        end,
        desc = "Send Harpoon List to Sidekick",
      },
    },
  }
}
