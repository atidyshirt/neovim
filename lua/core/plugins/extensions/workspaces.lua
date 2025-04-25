return {
  {
    "atidyshirt/neoscopes",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        version = "^1.0.0",
      },
    },
    opts = {
      enable_scopes_from_npm = true,
      scopes = {
        { name = "root", dirs = {} },
      },
    },
    config = function(_, opts)
      require('telescope').load_extension('live_grep_args')
      require("neoscopes").setup(opts)
      local scopes = require "neoscopes"
      if vim.fn.filereadable(vim.fn.stdpath "config" .. "/lua/scopes.lua") == 1 then
        for _, scope in ipairs(require "scopes") do
          scopes.add(scope)
        end
      end

      scopes.set_current('root')

      vim.keymap.set("n", "<leader>ws", function()
        require("neoscopes").select {}
      end, { desc = "Select scope" })

      local function get_search_dirs()
        if scopes.get_current_scope() == "root" then
          return nil
        end
        return scopes.get_current_paths()
      end

      _G.neoscopes_find_files = function()
        require("telescope.builtin").find_files {
          search_dirs = get_search_dirs(),
        }
      end
      _G.neoscopes_live_grep = function()
        require("telescope").extensions.live_grep_args.live_grep_args {
          search_dirs = get_search_dirs(),
        }
      end

      vim.keymap.set(
        "n",
        "<leader>ff",
        "<Cmd>lua neoscopes_find_files()<CR>",
        { desc = "Find files (scoped)" }
      )
      vim.keymap.set(
        "n",
        "<leader>fw",
        "<Cmd>lua neoscopes_live_grep()<CR>",
        { desc = "Live grep (scoped)" }
      )
    end,
  },
}
