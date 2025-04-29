---@module "config.lsp.lsp-setup-service"
---@alias ServerName string
---@alias ServerOpts table
---@alias AttachHandlers table<ServerName, fun(client: lsp.Client, buffer: integer)>
---@class LspSetupOpts
---@field servers table<ServerName, ServerOpts>
---@field attach_handlers AttachHandlers

local M = {}

local util = require("core.util")
local mason = require("mason-lspconfig")
local mason_server_mappings = require("mason-lspconfig.mappings.server")
local blink = require("blink.cmp")

---@return lsp.ClientCapabilities
local function get_capabilities()
  local base_caps = vim.lsp.protocol.make_client_capabilities()
  local enhanced_caps = util.capabilities(base_caps)
  return blink.get_lsp_capabilities(enhanced_caps)
end

---@param opts LspSetupOpts
function M.attach_lsp_handlers(opts)
  if not opts then return end

  local capabilities = get_capabilities()
  local available_servers = vim.tbl_keys(mason_server_mappings.lspconfig_to_package)
  local ensure_installed = {}

  ---@param server ServerName
  local function setup(server)
    local server_opts = vim.tbl_deep_extend("force", {
      capabilities = vim.deepcopy(capabilities)
    }, opts.servers[server] or {})

    if opts.attach_handlers[server] then
      util.on_attach(function(client, buffer)
        if client.name == server then
          opts.attach_handlers[server](client, buffer)
        end
      end)
    end

    require("lspconfig")[server].setup(server_opts)
  end

  for server, server_opts in pairs(opts.servers) do
    if server_opts then
      if not vim.tbl_contains(available_servers, server) then
        setup(server)
      else
        table.insert(ensure_installed, server)
      end
    end
  end

  mason.setup({
    ensure_installed = ensure_installed,
    automatic_installation = false,
  })
  mason.setup_handlers({ setup })
end

function M.attach_diagnostics()
  vim.diagnostic.config(require("config.lsp.diagnostics").on)
end

return M
