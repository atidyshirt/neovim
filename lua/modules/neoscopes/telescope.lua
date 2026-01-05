local scopes = require("neoscopes")

local M = {}

local function get_search_dirs()
  return scopes.get_current_scope() == "root" and nil or scopes.get_current_paths()
end

function M.find_files()
  require("telescope.builtin").find_files({ search_dirs = get_search_dirs(), hidden = true })
end

function M.live_grep()
  require("telescope").extensions.live_grep_args.live_grep_args({ search_dirs = get_search_dirs() })
end

function M.live_grep_current_word()
  require("telescope").extensions.live_grep_args.live_grep_args({
    search_dirs = get_search_dirs(),
    default_text = vim.fn.expand("<cword>"),
  })
end

return M
