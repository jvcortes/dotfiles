require('config.options')
require("config.lazy")
require("config.dashboard")
require('config.ui.config')
require('config.ui.code')
require('config.ts')
require('config.colors')

vim.api.nvim_create_autocmd('User', {
	pattern = 'ConfigLocalFinished',
	callback = function()
		require('config.lsp')
	end,
})

require('config.mappings')
