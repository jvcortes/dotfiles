return {
	'windwp/windline.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	event = 'UiEnter',
	config = function()
		require('config.ui.statusline')
	end
}
