return {
	{
		'VonHeikemen/lsp-zero.nvim',
		lazy = true,
		config = false,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
		},
	},
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
			},
		},
	},
	{
		'williamboman/mason.nvim',
	},
	{
		'williamboman/mason-lspconfig.nvim',
	},
}
