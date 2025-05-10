require("spec.utils.global-mocks")
local env = require("config.environment")
local handler = require("config.icons.icons")
local defaults = require("config.icons.icon_defaults")
local busted = require('busted')
local assert = busted.assert

describe("Icons", function()
  before_each(function()
    env.nerd_font_enabled = nil
  end)

  describe("with nerd fonts enabled", function()
    before_each(function()
      env.nerd_font_enabled = true
    end)

    it("should use default icons", function()
      local icons = handler.getIcons()
      assert.equals(defaults.diagnostics.error, icons.diagnostics.error)
      assert.equals(defaults.gitsigns.add, icons.gitsigns.add)
      assert.equals(defaults.kinds.Class, icons.kinds.Class)
      assert.equals(defaults.bbq_symbols.modified, icons.bbq_symbols.modified)
    end)
  end)

  describe("with nerd fonts disabled", function()
    before_each(function()
      env.nerd_font_enabled = false
    end)

    it("should override diagnostics icons with text", function()
      local icons = handler.getIcons()
      assert.equals("E", icons.diagnostics.error)
      assert.equals("W", icons.diagnostics.warn)
      assert.equals("H", icons.diagnostics.hint)
      assert.equals("I", icons.diagnostics.info)
    end)

    it("should override gitsigns icons with text", function()
      local icons = handler.getIcons()
      assert.equals("+", icons.gitsigns.add)
      assert.equals("+", icons.gitsigns.change)
      assert.equals("-", icons.gitsigns.delete)
      assert.equals("u", icons.gitsigns.untracked)
    end)

    it("should override kinds with empty strings", function()
      local icons = handler.getIcons()
      assert.equals("", icons.kinds.Class)
      assert.equals("", icons.kinds.Constant)
      assert.equals("", icons.kinds.Constructor)
      assert.equals("", icons.kinds.Enum)
      assert.equals("", icons.kinds.Field)
    end)

    it("should override bbq symbols", function()
      local icons = handler.getIcons()
      assert.equals("<", icons.bbq_symbols.modified)
      assert.equals(">", icons.bbq_symbols.separator)
    end)

    it("should override noice icons", function()
      local icons = handler.getIcons()
      assert.equals(" > ", icons.noice.cmdline.icon)
      assert.equals("/", icons.noice.search_down.icon)
      assert.equals("/", icons.noice.search_up.icon)
      assert.equals(" > ", icons.noice.lua.icon)
    end)
  end)

  describe("override behavior", function()
    it("should handle toggling nerd fonts", function()
      env.nerd_font_enabled = false
      local icons = handler.getIcons()
      assert.equals("E", icons.diagnostics.error)
      assert.equals("", icons.kinds.Class)

      env.nerd_font_enabled = true
      icons = handler.getIcons()
      assert.equals(defaults.diagnostics.error, icons.diagnostics.error)
      assert.equals(defaults.kinds.Class, icons.kinds.Class)

      env.nerd_font_enabled = false
      icons = handler.getIcons()
      assert.equals("E", icons.diagnostics.error)
      assert.equals("", icons.kinds.Class)
    end)
  end)
end)
