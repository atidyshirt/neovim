return {
  "mfussenegger/nvim-lint",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters.oxlint.on_output = function(_, _)
      vim.api.nvim_exec_autocmds("User", { pattern = "DiagnosticChanged" })
    end

    lint.linters_by_ft = {
      javascript = { "oxlint" },
      typescript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescriptreact = { "oxlint" },
      sh = { "shellcheck" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
      css = { "stylelint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
	lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command(
      "Lint",
      function () lint.try_lint() end,
      { desc = "Trigger linting for current file" }
    )
  end,
}
