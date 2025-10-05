local Util = require("core.util")

-- Highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = Util.augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = Util.augroup("close_with_q"),
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = Util.augroup("wrap_spell"),
  pattern = { "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "" },
  callback = function()
    local get_project_dir = function()
      local cwd = vim.fn.getcwd()
      local project_dir = vim.split(cwd, "/")
      local project_name = project_dir[#project_dir]
      return project_name
    end
    vim.opt.titlestring = get_project_dir()
  end,
})

-- auto enter terminal mode when opening a terminal/navigating to a terminal
vim.api.nvim_create_autocmd({"BufWinEnter", "BufEnter", "TermOpen", "TermEnter"}, {
  pattern = "term://*",
  callback = function()
    vim.defer_fn(function() vim.cmd("startinsert!") end, 50)
  end,
})
