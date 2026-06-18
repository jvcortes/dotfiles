vim.diagnostic.config({
	float = {
		border = "single", -- or "rounded", "double", or a table for custom borders
		update_in_insert = true,
		severity_sort = true,
	},
	virtual_text = false
})

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
