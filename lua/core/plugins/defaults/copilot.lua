return {
  {
    "folke/sidekick.nvim",
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
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
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
