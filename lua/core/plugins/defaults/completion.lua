local completion_ui_opts = {
  columns = {
    { "label", "label_description", gap = 1 },
    { "kind_icon", "kind" }
  },
}

local function get_completion_opts_if_ai_is_enabled()
  if vim.g.ai_integration_enabled then
    return {
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false }, },
      list = { selection = { preselect = false, auto_insert = true } },
      menu = {
	auto_show = false,
	draw = completion_ui_opts,
      },
    }
  end
  return {
    menu = {
      auto_show = true,
      draw = completion_ui_opts,
    }
  }
end

return {
  -- AI Integration
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    enabled = vim.g.ai_integration_enabled,
    opts = {
      keymaps = {
	accept_suggestion = '<Tab>',
      },
      log_level = 'off',
    },
  },
  -- LSP Completion
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
	preset = 'none',
	['<C-h>'] = { 'show_documentation', 'hide_documentation' },
	['<C-e>'] = { 'cancel' },
	['<C-l>'] = { 'accept' },
	['<Return>'] = { 'accept', 'fallback' },
	['<C-j>'] = { 'select_next', 'show', 'fallback' },
	['<C-k>'] = { 'select_prev', 'show', 'fallback' },
	['<C-d>'] = { 'scroll_documentation_up', 'fallback' },
	['<C-u>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
	nerd_font_variant = 'normal',
	use_nvim_cmp_as_default = true,
      },
      completion = get_completion_opts_if_ai_is_enabled(),
      sources = { default = { 'lsp', 'buffer', 'path' } },
      fuzzy = {
	implementation = 'prefer_rust_with_warning',
	prebuilt_binaries = { ignore_version_mismatch = true },
      },
      signature = { enabled = true, window = { show_documentation = false } },
      cmdline = {
	keymap = {
	  preset = 'inherit',
	  ['<Return>'] = { 'fallback' },
	},
      },
    },
    opts_extend = { 'sources.default' },
  },
}
