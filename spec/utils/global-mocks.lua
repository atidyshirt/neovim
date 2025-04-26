_G.vim = _G.vim or {}
vim.g = {}

vim.notify = function() end

vim.log = { levels = { ERROR = "error", INFO = "info" } }

vim.fn = {
  findfile = function(filename, path)
    if filename == ".nvim-settings.json" then
      return "" -- Simulate not found by default
    end
    return ""
  end,
  readfile = function(path)
    return { '{"my_setting": 42}' }
  end
}
vim.json = {
  decode = function(str)
    return { my_setting = 42 }
  end
}

vim.tbl_deep_extend = function(mode, ...)
  -- Simple deep extend mock for test purposes
  local result = {}
  for _, tbl in ipairs({...}) do
    for k, v in pairs(tbl) do
      result[k] = v
    end
  end
  return result
end

vim.schedule = function(fn) fn() end
