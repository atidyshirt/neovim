---@diagnostic disable: assign-type-mismatch : { cmd?: string }

---@type vim.lsp.ClientConfig
---@diagnostic disable-next-line: missing-fields : { cmd?: string }
return {
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.root(filename, { ".terraform", ".terraform.lock.hcl", ".git" }))
  end,

  -- Correct key for terraform-ls: init_options (not settings)
  init_options = {
    -- Exclude directories to prevent indexing issues
    indexing = {
      ignorePaths = {
        ".terraform/**",
        "**/.terraform/**",
        "node_modules/**",
        "**/node_modules/**",
        ".terragrunt-cache/**",
        "**/.terragrunt-cache/**",
      },
    },

    -- Disable expensive validation features that can cause hangs
    validation = {
      enableEnhancedValidation = false,
    },

    experimentalFeatures = {
      validateOnSave = true,
      prefillRequiredFields = true,
    },

    -- Log Terraform CLI executions for debugging
    terraform = {
      timeout = "30s",
    },
  },
}
