return {
	"rcarriga/nvim-notify",
	event = "VeryLazy",
	opts = {
	},
	config = function ()
		require('notify').setup({
			background_colour = '#000000',
			render = 'simple',
			level = 2,
			stages = 'fade'
		})
	end
}
