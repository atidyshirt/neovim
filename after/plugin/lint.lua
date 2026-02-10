vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-lint" }
})

local lint = require("lint")

lint.linters.oxlint.on_output = function(_, _)
  vim.api.nvim_exec_autocmds("User", { pattern = "DiagnosticChanged" })
end

local lsp_map = require("modules.lsp_mapping")
lint.linters_by_ft = lsp_map.get_linters_by_ft()

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_user_command(
  "Lint",
  function() lint.try_lint() end,
  { desc = "Trigger linting for current file" }
)
