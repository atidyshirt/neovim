vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "yamlls" then
      vim.cmd.packadd("yaml-schema-detect.nvim")
      require("yaml-schema-detect").setup({
        keymap = {
          refresh = "<leader>yr",
          cleanup = "<leader>yc",
          info = "<leader>yi"
        },
      })
    end
  end,
})
