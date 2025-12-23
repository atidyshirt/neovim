describe("LSP Configuration Smoke Test", function()
  local expected_servers = { "gopls", "lua_ls" }

  for _, server in ipairs(expected_servers) do
    it("should have a valid configuration for " .. server, function()
      local config = vim.lsp.config[server]

      assert.is_not_nil(config, "Configuration for " .. server .. " was not found in lsp/ directory")
      assert.is_not_nil(config.cmd, "Server " .. server .. " is missing a 'cmd' definition")
      --
      local bin = config.cmd[1]
      assert.equal(1, vim.fn.executable(bin), "Binary '" .. bin .. "' for " .. server .. " is not executable or in PATH")
    end)
  end
end)
