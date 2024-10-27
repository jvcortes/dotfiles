return {
    'numToStr/Comment.nvim',
	event = 'BufReadPre',
    opts = {
        -- add any options here
    },
	config = function ()
		require('Comment').setup()
	end
}
