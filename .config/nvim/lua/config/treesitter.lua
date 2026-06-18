local M = {}

local languages = { 'python', 'markdown', 'json', 'xml', 'javascript', 'typescript', 'tsx' }
local max_filesize = 100 * 1024 -- 100 KB

-- The main branch stores queries under runtime/queries/ which are only
-- copied to stdpath('data')/site/ by :TSInstall. Until tree-sitter-cli
-- is available, add the runtime/ dir to rtp so queries are found.
local plugin_dir = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
vim.o.rtp = plugin_dir .. '/runtime,' .. vim.o.rtp

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('UserTreesitter', { clear = true }),
	pattern = languages,
	callback = function(args)
		local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
		if ok and stats and stats.size > max_filesize then
			return
		end
		vim.treesitter.start()
	end,
})

return M
