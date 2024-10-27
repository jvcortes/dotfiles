local lsp_zero = require('lsp-zero')
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
	local opts = {buffer = bufnr, remap = false}

	vim.keymap.set('n', 'gd', function ()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set('n', 'K', function ()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set('n', '<leader>vws', function ()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set('n', '<leader>vd', function ()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set('n', '[d', function ()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set('n', 'd]', function ()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set('n', '<leader>vca', function ()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set('n', '<leader>vrr', function ()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set('n', '<leader>vrn', function ()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set('i', '<C-h>', function ()
		vim.lsp.buf.signature_help()
	end, opts)
end)

require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
require('lspconfig').pylsp.setup{}

require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		lsp_zero.default_setup
	}
})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
	sources = {
		{name = 'nvim_lsp'},
		{name = 'neorg'},
		{name = 'buffer'},
		{name = 'path'},
		{name = 'luasnip'},
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4)
	}),
	enabled = function ()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("org%-roam%-select$") ~= nil then
			return false
		end
		return true
	end
})

