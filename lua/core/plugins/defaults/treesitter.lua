local function disable_ts_for_large_files(lang, buf)
  local max_filesize = 100 * 1024
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "query",
        "regex",
        "tsx",
        "typescript",
        "yaml",
        "scss",
        "dockerfile",
      },
      highlight = {
        enable = true,
        disable = disable_ts_for_large_files,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = { "yaml", "python", "html" } },
      context_commentstring = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    opts = { enable = true },
  },
}
