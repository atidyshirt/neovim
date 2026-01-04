---@diagnostic disable: undefined-field
describe("lazyload", function()
  local lazyload = require("utils.lazyload")

  local function with_mock_pack(function_under_test)
    local calls = {}
    local orig = vim.pack.add

    vim.pack.add = function(specs, opts)
      table.insert(calls, { specs = specs, opts = opts or {} })
    end

    function_under_test()

    vim.pack.add = orig
    return calls
  end

  it("registers packages with opt=true immediately (not loaded)", function()
    local calls = with_mock_pack(function()
      lazyload({ packs = { { src = "test" } } })
    end)
    assert.equals(1, #calls)
    assert.is_true(calls[1].specs[1].opt)
  end)

  it("fires setup() and loads packs on events", function()
    local calls = with_mock_pack(function()
      local setup_ran = false
      lazyload({
        packs = { { src = "test" } },
        trigger = { "User" },
        setup = function() setup_ran = true end,
      })
      vim.api.nvim_exec_autocmds("User", { data = {} })
      return setup_ran
    end)
    assert.is_true(calls[2].opts.load)
  end)

  it("honors once loading flag", function()
    local setup_count = 0
    with_mock_pack(function()
      lazyload({
        packs = { { src = "test" } },
        trigger = { "User" },
        once = true,
        setup = function() setup_count = setup_count + 1 end,
      })
      vim.api.nvim_exec_autocmds("User", { data = {} })
      vim.api.nvim_exec_autocmds("User", { data = {} })
    end)
    assert.equals(1, setup_count)
  end)

  it("handles multiple packages", function()
    local calls = with_mock_pack(function()
      lazyload({ packs = { { src = "a" }, { src = "b" } } })
    end)
    assert.equals(2, #calls[1].specs)
  end)

  it("matches specific autocmd patterns", function()
    local setup_ran = false
    with_mock_pack(function()
      lazyload({
        packs = { { src = "test" } },
        trigger = { "BufEnter" },
        pattern = { "*.lua", "*.vim" },
        setup = function() setup_ran = true end,
      })

      -- This should NOT match (wrong pattern)
      vim.api.nvim_exec_autocmds("BufEnter", {
        data = {},
        pattern = "README.md"
      })
      assert.is_false(setup_ran)

      -- This should match (*.lua)
      vim.api.nvim_exec_autocmds("BufEnter", {
        data = {},
        pattern = "init.lua"
      })
      assert.is_true(setup_ran)
    end)
  end)
end)
