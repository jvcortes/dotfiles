-- Per-project LSP server overrides via .nvim.lua (vim.opt.exrc = true).
--
--   -- Switch to a different pre-configured server:
--   vim.g.lsp_servers = { typescript = "ts_ls" }
--   vim.g.lsp_servers = { typescript = "tsgo" }
--
--   -- Disable a language server entirely:
--   vim.g.lsp_servers = { typescript = false }
--
--   -- Provide a full custom server config:
--   vim.g.lsp_servers = {
--     python = {
--       name = "pylsp",
--       config = {
--         settings = {
--           pylsp = { plugins = { pycodestyle = { enabled = false } } }
--         }
--       }
--     }
--   }
--
local blink = require("blink.cmp")
local servers = require("config.lsp.servers")
local fidget = require("fidget")
local mason = require("mason")

local capabilities = blink.get_lsp_capabilities({}, false)

fidget.setup({})
mason.setup()

-- Map filetypes to the language key in servers.lua.
-- A FileType autocommand uses this to enable the right LSP lazily,
-- after .nvim.lua has had a chance to set vim.g.lsp_servers.
local ft_to_lang = {
	lua = 'lua',
	python = 'python',
	javascript = 'typescript',
	javascriptreact = 'typescript',
	typescript = 'typescript',
	typescriptreact = 'typescript',
}

-- Track which languages have already been enabled to avoid double setup.
local enabled_langs = {}

local function enable_for_filetype(ft)
	local lang = ft_to_lang[ft]
	if not lang or enabled_langs[lang] then
		return
	end

	local config = servers[lang]
	if not config then
		return
	end

	-- Check for project-specific server override (set in .nvim.lua)
	local override = vim.g.lsp_servers and vim.g.lsp_servers[lang]

	-- false = disable LSP for this language in this project
	if override == false then
		enabled_langs[lang] = true
		return
	end

	local server_name, server_config = nil, nil

	if type(override) == 'table' then
		-- Full custom config: { name = "...", config = {...} }
		server_name = override.name
		server_config = vim.tbl_deep_extend('force', {
			capabilities = capabilities,
		}, override.config or {})
	else
		-- String override or default: pick from pre-configured servers
		server_name = type(override) == 'string' and override or config.use
		for _, srv in pairs(config.servers) do
			if srv.name == server_name then
				server_config = vim.tbl_deep_extend('force', {
					capabilities = capabilities,
				}, srv.config)
				break
			end
		end
	end

	if server_config then
		vim.lsp.config(server_name, server_config)
		vim.lsp.enable(server_name)
		enabled_langs[lang] = true
	end
end

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('UserLspEnable', { clear = true }),
	pattern = vim.tbl_keys(ft_to_lang),
	callback = function(args)
		enable_for_filetype(args.match)
	end,
})

vim.diagnostic.config({
	update_in_insert = true,
	signs = true,
	virtual_text = true,
	float = {
		focusable = false,
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})
