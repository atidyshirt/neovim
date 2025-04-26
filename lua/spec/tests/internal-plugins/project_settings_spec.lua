---@diagnostic disable: no-unknown
require("spec.utils.global-mocks")
local busted = require('busted')
local assert = busted.assert

describe("project-settings", function()
  ---@class ProjectSettingsModule
  local project_settings = {}
  before_each(function()
    vim.g = {}
    package.loaded["project-settings"] = nil
    project_settings = require("core.internal-plugins.project-settings")
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
    project_settings.apply_settings()
    assert.is_false(called)
  end)

  it("applies default settings if no file found", function()
    project_settings.setup({ default_settings = { foo = "bar" } })
    project_settings.apply_settings()
    assert.are.equal(vim.g.foo, "bar")
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
    assert.are.equal(vim.g.my_setting, 99)
    assert.are.equal(vim.g.foo, "bar")
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
    assert.are.equal(vim.g.foo, "bar")
  end)
end)
