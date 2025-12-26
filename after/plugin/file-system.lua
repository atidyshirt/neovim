vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons", opt = true },
  { src = "https://github.com/stevearc/oil.nvim", opt = true },
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_user_command("Oil", function(opts)
  vim.cmd.packadd("nvim-web-devicons")
  vim.cmd.packadd("oil.nvim")

  if not package.loaded["oil"] then
    require("nvim-web-devicons").setup({})
    require("oil").setup({
      columns = { "icon" },
      view_options = { show_hidden = true },
    })
  end

  vim.cmd("Oil " .. table.concat(opts.fargs, " "))
end, {
  nargs = "*",
  complete = "dir",
  desc = "Edit directory with oil.nvim",
})
