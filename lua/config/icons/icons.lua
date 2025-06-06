local defaults = require('config.icons.icon_defaults')

---@class TextIconOverrideHandler
local TextIconOverrideHandler = {}

function TextIconOverrideHandler:new(icons)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    self.icons = icons
    return obj
end

function TextIconOverrideHandler:override_diagnostics ()
  self.icons.diagnostics = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  }
end

function TextIconOverrideHandler:override_gitsigns ()
  self.icons.gitsigns = {
      add = "+",
      change = "+",
      delete = "-",
      topdelhfe = "-",
      changedelete = "+",
      untracked = "u",
    }
end

function TextIconOverrideHandler:override_noice ()
  self.icons.noice = {
    cmdline = { icon = " > " },
    search_down = { icon = "/" },
    search_up = { icon = "/" },
    lua = { icon = " > " },
  }
end

function TextIconOverrideHandler:override_bbq ()
  self.icons.bbq_symbols.modified = '<'
  self.icons.bbq_symbols.separator = '>'
end

function TextIconOverrideHandler:override_kinds ()
  local kinds = self.icons.kinds
  for name, _ in pairs(kinds) do
    kinds[name] = ""
  end
  self.icons.kinds = kinds
end

function TextIconOverrideHandler:override_icons_with_text_if_needed()
  local overrides = {
    self.override_diagnostics,
    self.override_gitsigns,
    self.override_kinds,
    self.override_bbq,
    self.override_noice,
  }
  if vim.env.nerd_font_enabled ~= true then
    for _, override_function in pairs(overrides) do
      override_function(self)
    end
  end
end

return {
  getIcons = function ()
    local text_icon_override_handler = TextIconOverrideHandler:new(defaults)
    text_icon_override_handler:override_icons_with_text_if_needed()
    return text_icon_override_handler.icons
  end
}
