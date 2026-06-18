local M = {}

local breakpoint_width = 90

local popup_filetypes = {
    noice = true,
    TelescopePrompt = true,
    TelescopeResults = true,
}

local mode_map = {
    n = { color = 1 }, no = { color = 1 }, nov = { color = 1 }, noV = { color = 1 },
    ['no\22'] = { color = 1 }, niI = { color = 1 }, niR = { color = 1 }, niV = { color = 1 },
    nt = { color = 1 },
    v = { color = 3 }, V = { color = 3 }, ['\22'] = { color = 3 },
    s = { color = 3 }, S = { color = 3 }, ['\19'] = { color = 3 },
    i = { color = 2 }, ic = { color = 2 }, ix = { color = 2 },
    R = { color = 4 }, Rc = { color = 4 }, Rx = { color = 4 }, Rv = { color = 4 },
    c = { color = 5 }, cv = { color = 5 }, ce = { color = 5 },
    r = { color = 5 }, rm = { color = 5 }, ['r?'] = { color = 5 },
    ['!'] = { color = 5 }, t = { color = 1 },
}

local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl and next(hl) then return hl end
    ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if ok and hl and next(hl) then return hl end
    return {}
end

local function to_hex(value)
    if type(value) ~= 'number' then return nil end
    return string.format('#%06x', value)
end

local function hl_color(name, key)
    return to_hex(get_hl(name)[key])
end

local function term_color(slot, fallback_group, fallback_key)
    return vim.g['terminal_color_' .. slot] or hl_color(fallback_group, fallback_key)
end

local function mode_info()
    local mode = vim.api.nvim_get_mode().mode
    return mode_map[mode] or mode_map[mode:sub(1, 1)] or { color = 7 }
end

local function is_wide()
    return vim.api.nvim_win_get_width(0) > breakpoint_width
end

local function has_lsp()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

local function has_git()
    local gitsigns = vim.b.gitsigns_status_dict
    return type(gitsigns) == 'table' and not vim.tbl_isempty(gitsigns)
end

local function buffer_not_empty()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

local function buffer_name(path_mode)
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return '[No Name]' end
    if path_mode == 'full' then return vim.fn.fnamemodify(name, ':~:.') end
    return vim.fn.fnamemodify(name, ':t')
end

local function lsp_name()
    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then return 'No Active Lsp' end
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
        end
    end
    return 'No Active Lsp'
end

local function git_value(key, icon)
    return function()
        local gitsigns = vim.b.gitsigns_status_dict or {}
        return string.format('%s %d', icon, gitsigns[key] or 0)
    end
end

local function git_branch()
    return vim.b.gitsigns_head or ''
end

local function quickfix_details()
    local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
    local info = is_loclist and vim.fn.getloclist(0, { title = 0, size = 0 }) or vim.fn.getqflist({ title = 0, size = 0 })
    return {
        label = is_loclist and '🚦 Location ' or '🚦 Quickfix ',
        title = info.title or '',
        size = info.size or 0,
    }
end

local function quickfix_label() return quickfix_details().label end
local function quickfix_title() return quickfix_details().title end
local function quickfix_total() return string.format(' Total : %d ', quickfix_details().size) end

local function trouble_mode()
    local win = vim.api.nvim_get_current_win()
    local trouble = vim.w[win] and vim.w[win].trouble or nil
    local mode = trouble and trouble.mode or nil
    if not mode then
        local ok, api = pcall(require, 'trouble.api')
        if ok then mode = api.last_mode end
    end
    if not mode then return 'Trouble' end
    local parts = vim.split(mode, '[%W_]+')
    for i, part in ipairs(parts) do
        parts[i] = part:sub(1, 1):upper() .. part:sub(2)
    end
    return table.concat(parts, ' ')
end

local function trouble_total()
    local ok, api = pcall(require, 'trouble.api')
    if not ok then return '' end
    local win = vim.api.nvim_get_current_win()
    local mode = vim.w[win] and vim.w[win].trouble and vim.w[win].trouble.mode or api.last_mode
    if not mode then return '' end
    local ok_items, items = pcall(api.get_items, { mode = mode })
    if not ok_items then return '' end
    return string.format(' Total : %d ', #items)
end

local function oil_directory()
    local ok, oil = pcall(require, 'oil')
    if not ok then return 'Oil' end
    local dir = oil.get_current_dir()
    if not dir or dir == '' then return 'Oil' end
    return vim.fn.fnamemodify(dir, ':~')
end

function M.setup()
    local palette = {
        bg       = term_color(0, 'StatusLine', 'bg') or hl_color('StatusLine', 'bg') or 'NONE',
        fg       = hl_color('StatusLine', 'fg') or term_color(7, 'StatusLine', 'fg') or 'NONE',
        inactive_bg = hl_color('StatusLineNC', 'bg') or hl_color('NormalNC', 'bg') or hl_color('Normal', 'bg') or 'NONE',
        inactive_fg = hl_color('StatusLineNC', 'fg') or hl_color('NormalNC', 'fg') or hl_color('Comment', 'fg') or 'NONE',
        red      = term_color(1, 'DiagnosticError', 'fg') or 'NONE',
        green    = term_color(2, 'String', 'fg') or 'NONE',
        yellow   = term_color(3, 'DiagnosticWarn', 'fg') or 'NONE',
        blue     = term_color(4, 'DiagnosticInfo', 'fg') or 'NONE',
        magenta  = term_color(5, 'Special', 'fg') or 'NONE',
        cyan     = term_color(6, 'DiagnosticHint', 'fg') or 'NONE',
        white    = hl_color('Normal', 'fg') or term_color(7, 'Normal', 'fg') or 'NONE',
        dim_bg   = hl_color('StatusLineNC', 'bg') or hl_color('NormalNC', 'bg') or 'NONE',
        violet   = term_color(13, 'Special', 'fg') or 'NONE',
        orange   = term_color(9, 'DiagnosticWarn', 'fg') or 'NONE',
    }

    local function mode_color()
        return term_color(mode_info().color, 'StatusLine', 'fg') or palette.fg
    end

    local config = {
        options = {
            component_separators = '',
            section_separators = '',
            theme = {
                normal = {
                    a = { fg = palette.fg, bg = palette.bg },
                    b = { fg = palette.fg, bg = palette.bg },
                    c = { fg = palette.fg, bg = palette.bg },
                },
                inactive = {
                    a = { fg = palette.inactive_fg, bg = palette.inactive_bg },
                    b = { fg = palette.inactive_fg, bg = palette.inactive_bg },
                    c = { fg = palette.inactive_fg, bg = palette.inactive_bg },
                },
            },
            globalstatus = false,
            disabled_filetypes = {
                statusline = { 'noice', 'TelescopePrompt', 'TelescopeResults' },
                winbar = {},
            },
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
                refresh_time = 16,
                events = {
                    'WinEnter', 'BufEnter', 'BufWritePost', 'SessionLoadPost',
                    'FileChangedShellPost', 'VimResized', 'Filetype',
                    'CursorMoved', 'CursorMovedI', 'ModeChanged',
                    'DiagnosticChanged', 'LspAttach', 'LspDetach',
                },
            },
        },
        sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {},
            lualine_x = {},
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_y = {},
            lualine_z = {},
            lualine_c = {
                {
                    function() return buffer_name('full') end,
                    color = { fg = palette.inactive_fg, bg = palette.inactive_bg },
                },
            },
            lualine_x = {
                { 'location', color = { fg = palette.inactive_fg, bg = palette.inactive_bg } },
                { 'progress', color = { fg = palette.inactive_fg, bg = palette.inactive_bg } },
            },
        },
        extensions = {},
    }

    local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
    end

    -- ── Left side ──

    ins_left {
        function() return '▊' end,
        color = function() return { fg = mode_color() } end,
        padding = { left = 0, right = 1 },
    }

    ins_left {
        function() return '' end,
        color = function() return { fg = mode_color() } end,
        padding = { right = 1 },
    }

    ins_left {
        'filesize',
        cond = buffer_not_empty,
    }

    ins_left {
        'filename',
        cond = buffer_not_empty,
        color = { fg = palette.magenta, gui = 'bold' },
    }

    ins_left { 'location' }

    ins_left { 'progress', color = { fg = palette.fg, gui = 'bold' } }

    ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
            error = { fg = palette.red },
            warn  = { fg = palette.yellow },
            info  = { fg = palette.cyan },
        },
    }

    -- ── Mid divider ──

    ins_left { function() return '%=' end }

    ins_left {
        lsp_name,
        icon = ' LSP:',
        color = { fg = palette.white, gui = 'bold' },
    }

    -- ── Right side ──

    ins_right {
        'o:encoding',
        fmt = string.upper,
        cond = is_wide,
        color = { fg = palette.green, gui = 'bold' },
    }

    ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false,
        color = { fg = palette.green, gui = 'bold' },
    }

    ins_right {
        'branch',
        icon = '',
        color = { fg = palette.violet, gui = 'bold' },
    }

    ins_right {
        'diff',
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        diff_color = {
            added    = { fg = palette.green },
            modified = { fg = palette.orange },
            removed  = { fg = palette.red },
        },
        cond = is_wide,
    }

    ins_right {
        function() return '▊' end,
        color = function() return { fg = mode_color() } end,
        padding = { left = 1 },
    }

    -- ── Extensions (qf / trouble / oil) ──

    local function slant(from_color, to_color)
        return {
            function() return '' end,
            color = { fg = from_color, bg = to_color },
            padding = 0,
        }
    end

    table.insert(config.extensions, {
        filetypes = { 'qf' },
        sections = {
            lualine_a = {
                { quickfix_label, color = { fg = palette.white, bg = palette.bg }, padding = { left = 1, right = 0 } },
                slant(palette.bg, palette.dim_bg),
            },
            lualine_b = {
                { quickfix_title, color = { fg = palette.cyan, bg = palette.dim_bg }, padding = { left = 1, right = 1 } },
                { quickfix_total, color = { fg = palette.cyan, bg = palette.dim_bg }, padding = { left = 0, right = 0 } },
            },
            lualine_c = {}, lualine_x = {}, lualine_y = {},
            lualine_z = {
                slant(palette.dim_bg, palette.bg),
                { function() return '🧛 ' end, color = { fg = palette.white, bg = palette.bg }, padding = { left = 0, right = 1 } },
            },
        },
    })

    table.insert(config.extensions, {
        filetypes = { 'trouble', 'Trouble' },
        sections = {
            lualine_a = {
                { function() return '🚦 Trouble ' end, color = { fg = palette.white, bg = palette.bg }, padding = { left = 1, right = 0 } },
                slant(palette.bg, palette.dim_bg),
            },
            lualine_b = {
                { trouble_mode, color = { fg = palette.cyan, bg = palette.dim_bg }, padding = { left = 1, right = 1 } },
                { trouble_total, color = { fg = palette.cyan, bg = palette.dim_bg }, cond = function() return trouble_total() ~= '' end, padding = { left = 0, right = 0 } },
            },
            lualine_c = {}, lualine_x = {}, lualine_y = {},
            lualine_z = {
                slant(palette.dim_bg, palette.bg),
                { function() return '🧛 ' end, color = { fg = palette.white, bg = palette.bg }, padding = { left = 0, right = 1 } },
            },
        },
    })

    table.insert(config.extensions, {
        filetypes = { 'oil' },
        sections = {
            lualine_a = {
                { function() return '  ' end, color = { fg = palette.bg, bg = palette.red }, padding = { left = 1, right = 0 } },
                slant(palette.red, palette.bg),
            },
            lualine_b = {
                { oil_directory, color = { fg = palette.white, bg = palette.bg }, padding = { left = 1, right = 1 } },
            },
            lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {},
        },
    })

    require('lualine').setup(config)
end

return M
