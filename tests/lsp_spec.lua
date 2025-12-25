describe("LSP Configuration Smoke Test", function()
  local original_executable

  before_each(function()
    original_executable = vim.fn.executable
    vim.fn.executable = function(bin)
      if bin == 'gopls' or bin == 'lua-language-server' then return 1 end
      return original_executable(bin)
    end
  end)

  after_each(function()
    vim.fn.executable = original_executable
  end)

  local expected_servers = { "gopls", "lua_ls" }

  for _, server in ipairs(expected_servers) do
    it("should have a valid, complete configuration for " .. server, function()
      local config = vim.lsp.config[server]

      assert.is_not_nil(config, "Configuration for " .. server .. " was not found")

      assert.is_not_nil(config.cmd, server .. " is missing 'cmd'")
      assert.equal(1, vim.fn.executable(config.cmd[1]), "Binary for " .. server .. " not executable")
    end)
  end
end)
