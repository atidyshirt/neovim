---@class LazyLoadSpec
---@field packs table<string, string>[] # List of vim.pack.add specs
---@field trigger? string|string[] # Autocmd event(s) that trigger loading
---@field pattern? string|string[] # Autocmd pattern(s) for event
---@field setup? fun() # Optional setup function
---@field keymaps? table<string, string|fun()> # Normal mode keymaps
---@field once? boolean # Whether to fire only once (default true)

--- Lazily load plugins on demand.
---@param spec LazyLoadSpec
local function lazyload(spec)
  vim.validate({
    packs = { spec.packs, "table" },
    trigger = { spec.trigger, { "table", "string" }, true },
    pattern = { spec.pattern, { "table", "string" }, true },
    setup = { spec.setup, "function", true },
    keymaps = { spec.keymaps, "table", true },
    once = { spec.once, "boolean", true },
  })

  local triggers = type(spec.trigger) == "table" and spec.trigger or { spec.trigger or "VimEnter" }
  local patterns = type(spec.pattern) == "table" and spec.pattern or (spec.pattern and { spec.pattern } or nil)
  local once = spec.once ~= false

  local opt_packs = vim.tbl_map(function(pack)
    return vim.tbl_extend("force", pack, { opt = true })
  end, spec.packs)
  vim.pack.add(opt_packs)

  vim.api.nvim_create_autocmd(triggers, {
    pattern = patterns,
    once = once,
    callback = function()
      for _, pack in ipairs(spec.packs) do
        local name = pack.src:match(".*/(.-)$") or pack.src
        if name:match("%.git$") then name = name:gsub("%.git$", "") end
        vim.cmd("packadd " .. name)
      end

      if spec.setup then
        pcall(spec.setup)
      end

      if spec.keymaps then
        for lhs, rhs in pairs(spec.keymaps) do
          vim.keymap.set("n", lhs, rhs, { silent = true })
        end
      end
    end,
  })
end

return lazyload
