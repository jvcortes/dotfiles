
" General configuration ---------------------- {{{

filetype off

set hidden

" Hybrid numbers
set number relativenumber

" Search and replace options
set incsearch
set hlsearch

" Split options
set foldlevelstart=0
set splitbelow
set splitright

" }}}

" Key bindings         ----------------------- {{{

" Leader key
let mapleader = "\<Space>"
let maplocalleader = ","

" Swap current line
noremap - dd p
noremap _ dd k P

" Disable escape and arrow keys
inoremap <esc> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Set escape key replacement
inoremap jk <esc>
inoremap JK <esc>
vnoremap ñ <esc>

" Split bindings
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>h :split<cr>

" Edit vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Capitalize word
inoremap <C-U> <esc>vawUea

" Capitalize entire word
nnoremap <C-U> vawU

" Buffer bindings
nnoremap <S-Tab> :bn<CR>
nnoremap <S-q> :bp<CR>
nnoremap <C-x> :bd<CR>

" Terminal bindings
command! -nargs=* Term 15split | terminal <args>
nnoremap <leader>t :Term<cr>
tnoremap ññ <C-\><C-n>

" EasyMotion bindings
map <leader><leader>l <Plug>(easymotion-sl)
map <leader><leader>o <Plug>(easymotion-bd-wl)

" Dirvish bindings
nnoremap - :Dirvish<cr>

" Git bindings
nnoremap <leader>s :Gstatus<CR>

" chmod current file with user ownership and execution permissions
nnoremap <C-m> :!chmod u+x %<CR>
" }}}

" General operator-pending mappings ---------------------- {{{

" Email addresses
onoremap in@ :<C-U>execute "normal! /@\\a*\\.\\a*\r:nohlsearch\rviW"<cr>

" }}}

" General abbreviations ----------------------- {{{

iabbrev p@ jfelipefc@gmail.com
iabbrev s@ javierfefc@gmail.com

" }}}

" Fuzzy finder configuration ------------------------- {{{

let $FZF_DEFAULT_COMMAND = 'rg --files --line-number --no-ignore --hidden --follow --no-messages --glob "!.{git,wine}/*"'

command! -bang -nargs=* FindH call fzf#vim#grep('rg --column --line-number --no-heading
			\ --fixed-strings --ignore-case --no-ignore --no-messages --follow
			\ --glob "!.{git,local,tmp,wine,cache}/*" --glob "!*.{gpg}" --color "always" '.shellescape(<q-args>), 1, <bang>0)

nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>z :Buffers<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>x :History<CR>
nnoremap <leader>m :History:<CR>

" }}}

" Plugin section ---------------------------- {{{

call plug#begin('~/.local/share/nvim/plugged')

" General use plugins
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'joonty/vdebug'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'alvan/vim-closetag', { 'for': 'html' }

" Autocompletion engine
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-ultisnips'
" if has('nvim')
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
  " Plug 'Shougo/deoplete.nvim'
  " Plug 'roxma/nvim-yarp'
  " Plug 'roxma/vim-hug-neovim-rpc'
" endif

" Linting engine
Plug 'neomake/neomake'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'

" File explorer
Plug 'justinmk/vim-dirvish'

" Snippet manager
Plug 'SirVer/ultisnips' | Plug 'phux/vim-snippets'

" EasyMotion
Plug 'easymotion/vim-easymotion'

" PHP Plugins
Plug 'StanAngeloff/php.vim', {'for': 'php' }
Plug 'stephpy/vim-php-cs-fixer', {'for': 'php' }
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install' }
Plug 'phpactor/ncm2-phpactor', {'for': 'php' }

" C/C++ Plugins
Plug 'ncm2/ncm2-pyclang', {'for': ['c', 'cpp']}

" Themes
Plug 'ntk148v/vim-horizon'
Plug 'jeffkreeftmeijer/vim-dim'

call plug#end()

" }}}

" Color scheme -------------------------- {{{

" Set color scheme
colo dim 

" Remove background colors
highlight Normal ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" }}}

" Plugin config --------------------------- {{{

" vim-airline config
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16_colors'
let g:airline#extensions#tabline#enabled = 1
set laststatus=2

" Dirvish config
let g:dirvish_relative_paths = 1

" Neomake config
autocmd! BufWritePost,BufEnter * Neomake

" UltiSnips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>" 

" ncm2 config
augroup ncm2
	autocmd!
	autocmd BufEnter * call ncm2#enable_for_buffer()
	autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
	autocmd User Ncm2PopupClose set completeopt=menuone
augroup END
set shortmess+=c

" deoplete config
" let g:deoplete#enable_at_startup = 1

" nerdcommenter config
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1

" autoclose config
let g:closetag_filenames ='*.html,*.xhtml,*.xml,*.phtml'

" }}}

" Filetype and buffer configuration -------------------------- {{{

" HTML config
augroup filetype_html
	autocmd!
	autocmd FileType html set tw=80
	autocmd FileType html set tabstop=4
	autocmd FileType html set softtabstop=0
	autocmd FileType html set expandtab
	autocmd FileType html set shiftwidth=2
	autocmd FileType html set smarttab
	autocmd BufNewFile,BufRead *.html setlocal nowrap
augroup END
let g:html_indent_script1 = "inc"

" PHP Config
augroup filetype_php
	autocmd!
	autocmd FileType php set tw=80
	autocmd FileType php set tabstop=8
	autocmd FileType php set softtabstop=0
	autocmd FileType php set expandtab
	autocmd FileType php set shiftwidth=4
	autocmd FileType php set smarttab
	autocmd FileType php nnoremap <C-m> :call phpactor#ContextMenu()<CR>
augroup END
let g:ultisnips_php_scalar_types = 1

" C config
augroup filetype_c
	autocmd!
	autocmd FileType c set tabstop=8
	autocmd FileType c set shiftwidth=8
	autocmd FileType c set smarttab
augroup END

" Neomake PHP config
let g:neomake_php_phpcs_args_standard = 'PSR2'

" Display warnings for phpcs error
function! SetWarningType(entry)
    let a:entry.type = 'W'
endfunction

function! SetErrorType(entry)
    let a:entry.type = 'E'
endfunction

function! SetMessageType(entry)
    let a:entry.type = 'M'
endfunction

let g:neomake_php_enabled_makers = ['phpmd', 'phpcs', 'phpstan', 'php']

" Markdown config
augroup filetype_md
	autocmd!
	autocmd FileType markdown onoremap ih :<C-U>execute 
	 \ "normal! ?^\\(==\\\|--\\)\\+$\r:nohlsearch\rkvg_"<CR>
	autocmd FileType markdown onoremap ah :<C-U>execute 
	 \ "normal! ?^\\(==\\\|--\\)\\+$\r:nohlsearch\rg_vk0"<CR>
augroup END

" Vimscript config
augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

" Neovim terminal config
augroup terminal
	autocmd!
	autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" }}}

" Commands --------- {{{

" create new shell script file
command! -nargs=1 Shnew edit <args> | set ft=sh | set syn=sh

" }}}
