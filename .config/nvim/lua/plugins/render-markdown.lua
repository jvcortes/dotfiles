return {
	'MeanderingProgrammer/render-markdown.nvim',
	enabled = true,
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
	},
	config = function()
		local render_markdown = require('render-markdown')
		render_markdown.setup({
			link = {
				enabled = true,
				render_modes = { 'n', 'c' }
			},
			anti_conceal = {
				enabled = false,
				ignore = {
					link = true
				}
			},
			render_modes = { 'n', 'c' },
			completions = { blink = { enabled = true } },
			heading = {
				backgrounds = {}
			},
			dash = {
				width = 80
			},
			win_options = {
				concealcursor = { default = 'nc', rendered = 'nc' },
			},
		})
	end
}
