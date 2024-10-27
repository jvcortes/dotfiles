return {
	'mbbill/undotree',
	event = 'BufReadPre',
	config = function ()
		vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
	end,
}
