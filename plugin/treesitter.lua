vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/windwp/nvim-ts-autotag", opt = true },
})

local ensure_installed = {
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
    "markdown",
    "markdown_inline",
    "go",
    "python",
}

require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
    sync_install = true,
    highlight = { enable = true },
    indent = { enable = true }
})

require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterCore", { clear = true }),
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        -- Exit if no parser is available
        if not lang then
            return
        end

        -- Large file check
        local max_filesize = 100 * 1024 -- 100KB
        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return
        end

        -- FIX: Use pcall to prevent errors in special buffers like Oil or Telescope
        -- Some filetypes might report a language but fail to initialize a parser
        if not pcall(vim.treesitter.start, buf, lang) then
            return
        end

        local disabled_indent = { "yaml", "python", "html" }

        if not vim.tbl_contains(disabled_indent, ft) then
            vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
        end
    end,
})

require("nvim-ts-autotag").setup({
    opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
    },
})
