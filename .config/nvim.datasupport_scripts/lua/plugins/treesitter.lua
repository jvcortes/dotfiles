return {
	{
		'nvim-treesitter/nvim-treesitter',
		version = 'v0.*.*',
		build = ':TSUpdate',
		event = 'BufReadPost',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-refactor'
		},
		opts = {
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = { "markdown" },
			},
			autopairs = { enable = true },
			autotag = { enable = true },
			indent = { enable = false },
			ensure_installed = { 'python', 'markdown', 'json', 'sql' },
			ignore_install = { 'org' },
			sync_install = true,
			auto_install = false,
			refactor = {
				highlight_definitions = {
					enable = true,
					clear_on_cursor_move = true,
				},
				highlight_current_scope = { enable = false },
			},
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
	{
		'nvim-treesitter/playground',
		event = 'BufReadPost',
	}
}
