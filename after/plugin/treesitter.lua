local lazyload = require("utils.lazyload")

lazyload({
  packs = {
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
  },
  trigger = { "BufReadPost", "BufNewFile" },
  setup = function()
    local treesitter = require("nvim-treesitter.configs")
    local autotag = require("nvim-ts-autotag")

    local parsers = {
      "bash", "html", "javascript", "json", "lua", "query", "regex",
      "tsx", "typescript", "yaml", "scss", "dockerfile",
      "markdown", "markdown_inline", "go", "python",
    }

    treesitter.setup({
      ensure_installed = parsers,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })

    autotag.setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterCore", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then return end

        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > 100 * 1024 then return end

        pcall(vim.treesitter.start, buf, lang)

        local no_indent = { "yaml", "python", "html" }
        if not vim.tbl_contains(no_indent, ft) then
          vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
      end,
    })
  end,
})
