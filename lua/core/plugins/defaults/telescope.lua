local ignore_patterns = require("config.ignore_patterns")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        version = "^1.0.0",
      },
    },
    cmd = "Telescope",
    version = false,
    opts = {
      defaults = {
        border = false,
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "   ",
        dynamic_preview_title = true,
        hl_result_eol = true,
        sorting_strategy = "ascending",
        file_ignore_patterns = ignore_patterns,
        results_title = "",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
      },
    },
    keys = {
      { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Go to definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "Go to references" },
      { "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Go to implementations" },
      { "<leader>fb", "<cmd> Telescope buffers <CR>" },
      { "<leader>fo", "<cmd> Telescope oldfiles <CR>" },
      { "<leader>fk", "<cmd> Telescope keymaps <CR>" },
    },
  },
  {
    'MagicDuck/grug-far.nvim',
    config = true,
    opts = {
      windowCreationCommand = 'split',
      keymaps = {
        replace = { n = '<localleader>r' },
        qflist = { n = '<localleader>q' },
        syncLocations = { n = '<localleader>s' },
        syncLine = { n = '<localleader>l' },
        historyOpen = { n = '<localleader>t' },
        historyAdd = { n = '<localleader>a' },
        pickHistoryEntry = { n = '<enter>' },
        refresh = { n = '<localleader>f' },
        openLocation = { n = '<localleader>o' },
        openNextLocation = { n = '<C-n>' },
        openPrevLocation = { n = '<C-p>' },
        abort = { n = '<localleader>b' },
        help = { n = 'g?' },
      },
    },
    keys = {
      { "<leader>fg", "<cmd> GrugFar <CR>" },
    },
  },
}
