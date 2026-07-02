package.path = package.path .. ":~/.luarocks/share/lua/5.1/?/init.lua"
vim.g.mapleader = " "
vim.g.netrw_browsex_viewer = "open"
vim.g.netrw_nogx = false

vim.keymap.set('n', '<leader>rw', vim.cmd.Ex, { desc = 'Open netrw' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Add readable descriptions to Neovim's built-in bracket navigation maps
-- so Telescope/which-key doesn't show raw Ex commands like ':bprevious'.
local builtin_nav_maps = {
	{ 'n', '[a', '<cmd>previous<CR>', 'Previous arg' },
	{ 'n', ']a', '<cmd>next<CR>', 'Next arg' },
	{ 'n', '[A', '<cmd>rewind<CR>', 'First arg' },
	{ 'n', ']A', '<cmd>last<CR>', 'Last arg' },

	{ 'n', '[b', '<cmd>bprevious<CR>', 'Previous buffer' },
	{ 'n', ']b', '<cmd>bnext<CR>', 'Next buffer' },
	{ 'n', '[B', '<cmd>brewind<CR>', 'First buffer' },
	{ 'n', ']B', '<cmd>blast<CR>', 'Last buffer' },

	{ 'n', '[q', '<cmd>cprevious<CR>', 'Previous quickfix' },
	{ 'n', ']q', '<cmd>cnext<CR>', 'Next quickfix' },
	{ 'n', '[Q', '<cmd>crewind<CR>', 'First quickfix' },
	{ 'n', ']Q', '<cmd>clast<CR>', 'Last quickfix' },
	{ 'n', '[<C-Q>', '<cmd>cpfile<CR>', 'Previous quickfix file' },
	{ 'n', ']<C-Q>', '<cmd>cnfile<CR>', 'Next quickfix file' },

	{ 'n', '[l', '<cmd>lprevious<CR>', 'Previous loclist' },
	{ 'n', ']l', '<cmd>lnext<CR>', 'Next loclist' },
	{ 'n', '[L', '<cmd>lrewind<CR>', 'First loclist' },
	{ 'n', ']L', '<cmd>llast<CR>', 'Last loclist' },
	{ 'n', '[<C-L>', '<cmd>lpfile<CR>', 'Previous loclist file' },
	{ 'n', ']<C-L>', '<cmd>lnfile<CR>', 'Next loclist file' },

	{ 'n', '[t', '<cmd>tprevious<CR>', 'Previous tag' },
	{ 'n', ']t', '<cmd>tnext<CR>', 'Next tag' },
	{ 'n', '[T', '<cmd>trewind<CR>', 'First tag' },
	{ 'n', ']T', '<cmd>tlast<CR>', 'Last tag' },
	{ 'n', '[<C-T>', '<cmd>ptprevious<CR>', 'Previous preview tag' },
	{ 'n', ']<C-T>', '<cmd>ptnext<CR>', 'Next preview tag' },
}

for _, map in ipairs(builtin_nav_maps) do
	vim.keymap.set(map[1], map[2], map[3], { desc = map[4] })
end

-- Override a few Neovim defaults with clearer descriptions while preserving behavior.
vim.keymap.set('n', 'Y', 'y$', { desc = 'Yank to end of line' })
vim.keymap.set('n', '&', ':&&<CR>', { desc = 'Repeat substitution with flags' })
vim.keymap.set('i', '<C-U>', '<C-G>u<C-U>', { desc = 'Delete to start of insert' })
vim.keymap.set('i', '<C-W>', '<C-G>u<C-W>', { desc = 'Delete previous word' })
vim.keymap.set(
	'x',
	'Q',
	"mode() ==# 'V' ? ':normal! @<C-R>=reg_recorded()<CR><CR>' : 'Q'",
	{ silent = true, expr = true, desc = 'Replay last macro on selection' }
)
vim.keymap.set(
	'x',
	'@',
	"mode() ==# 'V' ? ':normal! @'.getcharstr().'<CR>' : '@'",
	{ silent = true, expr = true, desc = 'Run macro on selection' }
)

local function visual_search(forward)
	assert(forward == 0 or forward == 1)
	local pos = vim.fn.getpos('.')
	local vpos = vim.fn.getpos('v')
	local mode = vim.fn.mode()
	local chunks = vim.fn.getregion(pos, vpos, { type = mode })
	local esc_chunks = vim.iter(chunks)
		:map(function(v)
			return vim.fn.escape(v, [[\\]])
		end)
		:totable()
	local esc_pat = table.concat(esc_chunks, [[\n]])
	if #esc_pat == 0 then
		vim.api.nvim_echo({ { 'E348: No string under cursor' } }, true, { err = true })
		return '<Esc>'
	end
	local search = [[\V]] .. esc_pat

	vim.fn.setreg('/', search)
	vim.fn.histadd('/', search)
	vim.v.searchforward = forward

	local count = vim.v.count1
	if forward == 0 then
		local _, line, col, _ = unpack(pos)
		local _, vline, vcol, _ = unpack(vpos)
		if line > vline or mode == 'v' and line == vline and col > vcol or mode == 'V' and col ~= 1 or mode == '\22' and col > vcol then
			count = count + 1
		end
	end
	return '<Esc>' .. count .. 'n'
end
vim.keymap.set('x', '*', function()
	return visual_search(1)
end, { expr = true, desc = 'Search selection forward' })
vim.keymap.set('x', '#', function()
	return visual_search(0)
end, { expr = true, desc = 'Search selection backward' })

vim.keymap.set('n', 'grn', function()
	vim.lsp.buf.rename()
end, { desc = 'Rename symbol' })
vim.keymap.set({ 'n', 'x' }, 'gra', function()
	vim.lsp.buf.code_action()
end, { desc = 'Code action' })
vim.keymap.set('n', 'grx', function()
	vim.lsp.codelens.run()
end, { desc = 'Run code lens' })
vim.keymap.set('n', 'grr', function()
	vim.lsp.buf.references()
end, { desc = 'References' })
vim.keymap.set('n', 'gri', function()
	vim.lsp.buf.implementation()
end, { desc = 'Implementation' })
vim.keymap.set('n', 'grt', function()
	vim.lsp.buf.type_definition()
end, { desc = 'Type definition' })
vim.keymap.set('n', 'gO', function()
	vim.lsp.buf.document_symbol()
end, { desc = 'Document symbols' })
vim.keymap.set({ 'i', 's' }, '<C-S>', function()
	vim.lsp.buf.signature_help()
end, { desc = 'Signature help' })

-- Add descriptions to matchit's user-facing maps so Telescope keymaps
-- shows readable helper text instead of raw <Plug> targets.
vim.api.nvim_create_autocmd('VimEnter', {
	once = true,
	callback = function()
		vim.keymap.set('n', '%', '<Plug>(MatchitNormalForward)', { remap = true, desc = 'Matchit forward' })
		vim.keymap.set('n', '[%', '<Plug>(MatchitNormalMultiBackward)', { remap = true, desc = 'Matchit multi backward' })
		vim.keymap.set('n', ']%', '<Plug>(MatchitNormalMultiForward)', { remap = true, desc = 'Matchit multi forward' })
		vim.keymap.set('n', 'g%', '<Plug>(MatchitNormalBackward)', { remap = true, desc = 'Matchit backward' })

		vim.keymap.set('x', '%', '<Plug>(MatchitVisualForward)', { remap = true, desc = 'Matchit forward' })
		vim.keymap.set('x', '[%', '<Plug>(MatchitVisualMultiBackward)', { remap = true, desc = 'Matchit multi backward' })
		vim.keymap.set('x', ']%', '<Plug>(MatchitVisualMultiForward)', { remap = true, desc = 'Matchit multi forward' })
		vim.keymap.set('x', 'a%', '<Plug>(MatchitVisualTextObject)', { remap = true, desc = 'Matchit textobject' })
		vim.keymap.set('x', 'g%', '<Plug>(MatchitVisualBackward)', { remap = true, desc = 'Matchit backward' })

		vim.keymap.set('o', '%', '<Plug>(MatchitOperationForward)', { remap = true, desc = 'Matchit forward' })
		vim.keymap.set('o', '[%', '<Plug>(MatchitOperationMultiBackward)', { remap = true, desc = 'Matchit multi backward' })
		vim.keymap.set('o', ']%', '<Plug>(MatchitOperationMultiForward)', { remap = true, desc = 'Matchit multi forward' })
		vim.keymap.set('o', 'g%', '<Plug>(MatchitOperationBackward)', { remap = true, desc = 'Matchit backward' })
	end,
})

vim.wo.fillchars='eob: '

vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = false
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.colorcolumn = '80'
vim.opt.exrc = true
