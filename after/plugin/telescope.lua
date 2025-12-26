local lazyload = require("utils.lazyload")

vim.pack.add({ { src = "https://github.com/atidyshirt/neoscopes" } })

---@diagnostic disable: missing-fields
require("neoscopes").setup({
  enable_scopes_from_npm = true,
  scopes = { { name = "root", dirs = {} } },
})

local scopes = require("neoscopes")

if vim.fn.filereadable(vim.fn.stdpath("config") .. "/lua/scopes.lua") == 1 then
  for _, scope in ipairs(require("scopes")) do
    scopes.add(scope)
  end
end
scopes.set_current("root")

lazyload({
  packs = {
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim" },
  },
  trigger = "CmdUndefined",
  pattern = "Telescope",
  setup = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.load_extension("live_grep_args")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-u>"] = false,
          },
        },
      },
    })
  end,
})

local function get_search_dirs()
  return scopes.get_current_scope() == "root" and nil or scopes.get_current_paths()
end

_G.neoscopes_find_files = function()
  require("telescope.builtin").find_files({ search_dirs = get_search_dirs() })
end

_G.neoscopes_live_grep = function()
  require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = get_search_dirs() })
end

_G.neoscopes_live_grep_current_word = function()
  require("telescope").extensions.live_grep_args.live_grep_args({
    search_dirs = get_search_dirs(),
    default_text = vim.fn.expand("<cword>"),
  })
end

vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, { desc = "Go to references" })
vim.keymap.set("n", "gi", function() require("telescope.builtin").lsp_implementations() end, { desc = "Go to implementations" })
vim.keymap.set("n", "<leader>ws", function() scopes.select() end, { desc = "Select scope" })
vim.keymap.set("n", "<leader>fs", "<Cmd>lua neoscopes_live_grep_current_word()<CR>", { desc = "Live grep current word (scoped)" })
vim.keymap.set("n", "<leader>ff", "<Cmd>lua neoscopes_find_files()<CR>", { desc = "Find files (scoped)" })
vim.keymap.set("n", "<leader>fw", "<Cmd>lua neoscopes_live_grep()<CR>", { desc = "Live grep (scoped)" })
