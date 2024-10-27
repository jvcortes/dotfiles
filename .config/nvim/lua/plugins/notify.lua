return {
	'rcarriga/nvim-notify',
	event = 'VimEnter',
	config = function ()
		require('notify').setup(
			{
				stages = 'fade',
				timeout = 6000
			}
		)
		vim.notify = require('notify')
	end
}
