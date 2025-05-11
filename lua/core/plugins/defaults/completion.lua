local util = require("core.util")

local completion_ui_opts = {
  columns = {
    { "label", "label_description", gap = 1 },
    { "kind_icon", "kind" }
  },
}

local function get_completion_opts_if_ai_is_enabled()
  if util.str_to_bool(vim.env.supermaven_enabled) or util.str_to_bool(vim.env.copilot_enabled) then
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

local function get_copilot_source_opts_if_ai_is_enabled()
  if util.str_to_bool(vim.env.copilot_enabled) then
    return {
	default = {
	  'copilot',
	  'lsp',
	  'buffer',
	  'path' ,
	},
	providers = {
	  copilot = {
	    name = "copilot",
	    module = "blink-copilot",
	    score_offset = 100,
	    async = true,
	    opts = {
	      max_completions = 3,
	    }
	  },
	},
    }
  end
  return { default = { 'lsp', 'buffer', 'path' } }
end

return {
  -- AI Integration
  {
    'github/copilot.vim',
    enabled = util.str_to_bool(vim.env.copilot_enabled),
  },
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    enabled = util.str_to_bool(vim.env.supermaven_enabled),
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
    dependencies = {
      "fang2hou/blink-copilot",
      enabled = util.str_to_bool(vim.env.copilot_enabled),
      opts = {
	max_completions = 1,
	max_attempts = 2,
      }
    },
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
      sources = get_copilot_source_opts_if_ai_is_enabled(),
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
