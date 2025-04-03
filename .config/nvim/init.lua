require('config.options')
require("config.lazy")
require("config.dashboard")
require('config.ui.config')
require('config.ui.code')
require('config.ts')

vim.api.nvim_create_autocmd('User', {
	pattern = 'VeryLazy',
	callback = function ()
		require('config.mappings')
	end,
})

require('config.colors')
