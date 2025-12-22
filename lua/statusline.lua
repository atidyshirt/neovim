local icons = require 'utils.icons'

local M = {}

vim.g.qf_disable_statusline = 1
vim.o.showmode = false

local statusline_hls = {}
function M.get_or_create_hl(hl)
  local hl_name = 'Statusline' .. hl
  if not statusline_hls[hl_name] then
    local bg_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
    local fg_hl = vim.api.nvim_get_hl(0, { name = hl })
    vim.api.nvim_set_hl(0, hl_name, {
      bg = ('#%06x'):format(bg_hl.bg),
      fg = ('#%06x'):format(fg_hl.fg)
    })
    statusline_hls[hl_name] = true
  end
  return hl_name
end

--- Git status (if any).
---@return string
function M.git_component()
    local head = vim.b.gitsigns_head
    if not head then
        return ''
    end

    return string.format('  %s', head)
end

---@type table<string, string?>
---@diagnostic disable-next-line: assign-type-mismatch
local last_diagnostic_component = ''
--- Diagnostic counts in the current buffer.
---@return string
function M.diagnostics_component()
    if vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
        return last_diagnostic_component
    end

    local counts = vim.iter(vim.diagnostic.get(0)):fold({
        ERROR = 0, WARN = 0, HINT = 0, INFO = 0,
    }, function(acc, diagnostic)
        local severity = vim.diagnostic.severity[diagnostic.severity]
        acc[severity] = (acc[severity] or 0) + 1
        return acc
    end)

    local parts = {}
    for severity, count in pairs(counts) do
        if count > 0 then
            local hl = 'Diagnostic' .. severity:sub(1, 1) .. severity:sub(2):lower()
            table.insert(parts, string.format('%%#%s#%s %d', M.get_or_create_hl(hl), icons.diagnostics[severity], count))
        end
    end

    return table.concat(parts, ' ')
end

--- The buffer's filetype.
---@return string
function M.filetype_component()
    local devicons = require 'nvim-web-devicons'

    local special_icons = {
        DressingInput = { '󰍩', 'Comment' },
        DressingSelect = { '', 'Comment' },
        OverseerForm = { '󰦬', 'Special' },
        OverseerList = { '󰦬', 'Special' },
        dapui_breakpoints = { icons.misc.bug, 'DapUIRestart' },
        dapui_scopes = { icons.misc.bug, 'DapUIRestart' },
        dapui_stacks = { icons.misc.bug, 'DapUIRestart' },
        fzf = { '', 'Special' },
        gitcommit = { icons.misc.git, 'Number' },
        gitrebase = { icons.misc.git, 'Number' },
        kitty_scrollback = { '󰄛', 'Conditional' },
        lazy = { icons.symbol_kinds.Method, 'Special' },
        lazyterm = { '', 'Special' },
        minifiles = { icons.symbol_kinds.Folder, 'Directory' },
        qf = { icons.misc.search, 'Conditional' },
        spectre_panel = { icons.misc.search, 'Constant' },
    }

    local filetype = vim.bo.filetype
    if filetype == '' then
        filetype = '[No Name]'
    end

    local icon, icon_hl
    if special_icons[filetype] then
        icon, icon_hl = unpack(special_icons[filetype])
    else
        local buf_name = vim.api.nvim_buf_get_name(0)
        local name, ext = vim.fn.fnamemodify(buf_name, ':t'), vim.fn.fnamemodify(buf_name, ':e')

        icon, icon_hl = devicons.get_icon(name, ext)
        if not icon then
            icon, icon_hl = devicons.get_icon_by_filetype(filetype, { default = true })
        end
    end
    icon_hl = M.get_or_create_hl(icon_hl)

    return string.format('%%#%s#%s %%#StatuslineTitle#%s', icon_hl, icon, filetype)
end

function M.position_component()
  return ' %3l:%-3v'
end

--- Renders the statusline.
---@return string
function M.render()
    ---@param components string[]
    ---@return string
    local function concat_components(components)
        return vim.iter(components):skip(1):fold(components[1], function(acc, component)
            return #component > 0 and string.format('%s    %s', acc, component) or acc
        end)
    end

    return table.concat {
        concat_components {
            M.git_component(),
        },
        '%#StatusLine#%=',
        concat_components {
            M.diagnostics_component(),
            M.filetype_component(),
            M.position_component(),
        },
        ' ',
    }
end

return M
