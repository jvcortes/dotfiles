return {
	{
		'nvim-treesitter/nvim-treesitter',
		branch = 'main',
		build = ':TSUpdate',
		lazy = false,
		config = function()
			require('nvim-treesitter').setup()
			require('config.treesitter')
		end,
	},
}
