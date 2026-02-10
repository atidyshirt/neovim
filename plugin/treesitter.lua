local lazyload = require("utils.lazyload")

local parsers = require("modules.lsp_mapping").get_treesitter_parsers()

lazyload({
  packs = {
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
  },
  trigger = "UIEnter",
  setup = function()
    local treesitter = require("nvim-treesitter")
    local autotag = require("nvim-ts-autotag")

    treesitter.setup({ install_dir = vim.fn.stdpath('data') .. '/site' })
    treesitter.install(parsers):wait(300000)

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
