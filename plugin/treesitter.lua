local function disable_ts_for_large_files(lang, buf)
  local max_filesize = 100 * 1024  -- 100KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/windwp/nvim-ts-autotag", opt = true },
})

require("nvim-treesitter").setup({
  ensure_installed = {
    "bash", "html", "javascript", "json", "lua", "query", "regex",
    "tsx", "typescript", "yaml", "scss", "dockerfile", "latex",
    "markdown", "markdown_inline", "typst",
  },

  highlight = {
    enable = true,
    disable = disable_ts_for_large_files,
    additional_vim_regex_highlighting = false,
  },
  
  indent = { 
    enable = true, 
    disable = { "yaml", "python", "html" } 
  },
  
  context_commentstring = { enable = true },
})

require("nvim-ts-autotag").setup({ enable = true })
