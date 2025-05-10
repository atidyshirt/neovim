---@diagnostic disable: no-unknown
require("spec.utils.global-mocks")
local busted = require('busted')
local assert = busted.assert

local original_os_getenv
local original_vim_fn_findfile
local original_vim_fn_readfile
local original_vim_json_decode

describe("project-settings", function()
  local project_settings = {}

  before_each(function()
    vim.env = {}
    package.loaded["core.internal-plugins.project-settings"] = nil
    project_settings = require("core.internal-plugins.project-settings")
    -- Save originals for restoration
    original_os_getenv = os.getenv
    original_vim_fn_findfile = vim.fn.findfile
    original_vim_fn_readfile = vim.fn.readfile
    original_vim_json_decode = vim.json.decode
  end)

  after_each(function()
    os.getenv = original_os_getenv
    vim.fn.findfile = original_vim_fn_findfile
    vim.fn.readfile = original_vim_fn_readfile
    vim.json.decode = original_vim_json_decode
  end)

  it("sets up with default config", function()
    project_settings.setup()
    assert.is_true(type(project_settings.setup) == "function")
    assert.is_true(type(project_settings.apply_settings) == "function")
  end)

  it("merges user config in setup", function()
    local called = false
    project_settings.setup({
      settings_file = "custom.json",
      on_error = function() called = true end,
      default_settings = { foo = 123 }
    })
    assert.is_false(called)
  end)

  it("applies default settings if no file found", function()
    vim.fn.findfile = function() return '' end
    project_settings.setup({ default_settings = { foo = "bar" } })
    project_settings.apply_settings()
    assert.are.equal(vim.env.foo, "bar")
  end)

  it("applies settings from JSON file", function()
    vim.fn.findfile = function(_filename, _path)
      return ".nvim-settings.json"
    end
    vim.fn.readfile = function(_path)
      return { '{"my_setting": 99}' }
    end
    vim.json.decode = function(_str)
      return { my_setting = 99 }
    end
    project_settings.setup({ default_settings = { foo = "bar" } })
    project_settings.apply_settings()
    assert.are.equal(vim.env.my_setting, 99)
    assert.are.equal(vim.env.foo, "bar")
  end)

  it("calls on_error on invalid JSON", function()
    local err_msg = nil
    vim.fn.findfile = function(_filename, _path) return ".nvim-settings.json" end
    vim.fn.readfile = function(_path) return { "invalid json" } end
    vim.json.decode = function(_str) error("decode error") end
    project_settings.setup({
      on_error = function(msg) err_msg = msg end,
      default_settings = { foo = "bar" }
    })
    project_settings.apply_settings()
    assert.is_truthy(err_msg)
    assert.are.equal(vim.env.foo, "bar")
  end)
end)

describe("project-settings loading order", function()
  local project_settings = {}

  before_each(function()
    vim.env = {}
    package.loaded["core.internal-plugins.project-settings"] = nil
    project_settings = require("core.internal-plugins.project-settings")
    -- Save and patch os.getenv
    original_os_getenv = os.getenv
    original_vim_fn_findfile = vim.fn.findfile
    original_vim_fn_readfile = vim.fn.readfile
    original_vim_json_decode = vim.json.decode
  end)

  after_each(function()
    os.getenv = original_os_getenv
    vim.fn.findfile = original_vim_fn_findfile
    vim.fn.readfile = original_vim_fn_readfile
    vim.json.decode = original_vim_json_decode
  end)

  it("prefers project setting over env var and default", function()
    vim.fn.findfile = function() return ".nvim-settings.json" end
    vim.fn.readfile = function() return { '{"my_setting": "from_file"}' } end
    vim.json.decode = function() return { my_setting = "from_file" } end
    os.getenv = function(var) if var == "MY_SETTING" then return "from_env" end end
    project_settings.setup({ default_settings = { my_setting = "from_default" } })
    project_settings.apply_settings()
    assert.are.equal(vim.env.my_setting, "from_file")
  end)

  it("uses default if neither project setting nor env var present", function()
    vim.fn.findfile = function() return '' end
    os.getenv = function(_) return nil end
    project_settings.setup({ default_settings = { my_setting = "from_default" } })
    project_settings.apply_settings()
    assert.are.equal(vim.env.my_setting, "from_default")
  end)
end)
