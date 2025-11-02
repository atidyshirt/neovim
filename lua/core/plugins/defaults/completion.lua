local util = require("core.util")

return {
  {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot_ls")
      vim.keymap.set("n", "<tab>", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
          or (
          require("copilot-lsp.nes").apply_pending_nes()
          and require("copilot-lsp.nes").walk_cursor_end_edit()
        )
          return nil
        else
          return "<C-i>"
        end
      end, { desc = "Accept Copilot NES suggestion", expr = true })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    version = "1.*",
    opts = {
      keymap = {
        keymap = {
          preset = "super-tab",
          ["<Tab>"] = {
            function(cmp)
              if vim.b[vim.api.nvim_get_current_buf()].nes_state then
                cmp.hide()
                return (
                  require("copilot-lsp.nes").apply_pending_nes()
                  and require("copilot-lsp.nes").walk_cursor_end_edit()
                )
              end
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },
        },
        ["<C-h>"] = { "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "cancel" },
        ["<C-l>"] = { "accept" },
        ["<Return>"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "show", "fallback" },
        ["<C-k>"] = { "select_prev", "show", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        nerd_font_variant = "normal",
        use_nvim_cmp_as_default = true,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          auto_show = true,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = { ignore_version_mismatch = true },
      },
      signature = { enabled = true, window = { show_documentation = false } },
      cmdline = {
        keymap = {
          preset = "inherit",
          ["<Return>"] = { "fallback" },
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      -- Add error handling for extmark issues
      local blink = require("blink.cmp")
      -- Wrap the setup function to handle extmark errors
      local original_setup = blink.setup
      blink.setup = function(config)
        local ok, result = pcall(original_setup, config)
        if not ok then
          vim.notify("Blink.cmp setup error: " .. tostring(result), vim.log.levels.WARN, { title = "Blink.cmp" })
        end
        return result
      end
      blink.setup(opts)
    end,
  },
}
