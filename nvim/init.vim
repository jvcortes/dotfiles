
" General configuration ---------------------- {{{

filetype off

set hidden
set rnu nu

" Search and replace options
set incsearch
set hlsearch

" Split options
set foldlevelstart=0
set splitbelow
set splitright

" }}}

" General key bindings         ----------------------- {{{

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
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>wh :split<cr>

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

" ctrl backspace 
noremap! <C-BS> <C-W>
noremap! <C-h> <C-W>

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
Plug 'mhinz/vim-startify'
Plug 'guns/xterm-color-table.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'gioele/vim-autoswap'
Plug 'jiangmiao/auto-pairs'
Plug 'jceb/vim-orgmode'

" Debugging
Plug 'joonty/vdebug'
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

" EasyMotion
Plug 'easymotion/vim-easymotion'

" Autocompletion engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Linting engine
Plug 'neomake/neomake', {'for': ['c', 'sh', 'bash', 'zsh']}

" Statusline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" File explorer
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'

" Snippet manager
Plug 'SirVer/ultisnips' | Plug 'phux/vim-snippets'

" PHP Plugins
Plug 'StanAngeloff/php.vim', {'for': 'php' }
Plug 'stephpy/vim-php-cs-fixer', {'for': 'php' }

" Python plugins
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}

" HTML/CSS Plugins
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'

Plug 'arzg/vim-substrata'
Plug 'morhetz/gruvbox'
Plug 'dylanaraps/wal.vim'
Plug 'srcery-colors/srcery-vim'

call plug#end()

" }}}

" Color scheme -------------------------- {{{

" Set color scheme
colorscheme srcery

" Remove background colors
highlight Normal ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
highlight Pmenu ctermbg=15 ctermfg=0
highlight PmenuSel ctermbg=15 ctermfg=0 cterm=reverse

" coc highlighting
highlight CocErrorSign ctermfg=0
highlight CocWarningSign ctermfg=0
highlight CocInfoSign ctermfg=0
highlight CocHintSign ctermfg=0

" easymotion highlighting
highlight EasyMotionTarget ctermfg=1

" python highlighting

let s:palette = g:lightline#colorscheme#wal#palette
let s:palette.tabline.tabsel = [ [ '#d0d0d0', '#5f8787', 5, 0, 'bold' ] ]
unlet s:palette 
" }}}

" Plugin config --------------------------- {{{

" python neovim config

" lightline config
let g:lightline = {
  \   'colorscheme': 'wal',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ]
  \   },
	\   'component': {
	\     'lineinfo': ' %3l:%-2v',
	\   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }
let g:lightline.tabline = {'left' : [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}

set laststatus=2
set showtabline=2

" Dirvish config
let g:dirvish_relative_paths = 0

" " UltiSnips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>" 

" coc config
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

xmap <leader>o <Plug>(coc-format-selected)
nmap <leader>o <Plug>(coc-format-selected)

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
 	autocmd FileType html nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END
let g:html_indent_script1 = "inc"

" CSS config
augroup filetype_css
	autocmd!
	autocmd FileType css set tw=80
	autocmd FileType css set tabstop=4
	autocmd FileType css set softtabstop=0
	autocmd FileType css set expandtab
	autocmd FileType css set shiftwidth=2
	autocmd FileType css set smarttab
 	autocmd FileType css nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

" CSS config
augroup filetype_scss
	autocmd!
	autocmd FileType scss set tw=80
	autocmd FileType scss set tabstop=4
	autocmd FileType scss set softtabstop=0
	autocmd FileType scss set expandtab
	autocmd FileType scss set shiftwidth=2
	autocmd FileType scss set smarttab
 	autocmd FileType scss nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

" Puppet config
augroup filetype_pp
	autocmd!
	autocmd	FileType pp set tabstop=8
	autocmd FileType pp set softtabstop=0
	autocmd FileType pp set expandtab
	autocmd FileType pp set shiftwidth=2
	autocmd FileType pp set smarttab
augroup END

" C config
augroup filetype_c
	autocmd!
	autocmd FileType c set tabstop=8
	autocmd FileType c set shiftwidth=8
	autocmd FileType c set smarttab
	autocmd FileType c set smartindent
	autocmd FileType c set cindent
	autocmd FileType c nnoremap <F10> :w<CR> :!clear<CR> :!gcc % && ./a.out <CR>
	autocmd FileType c call neomake#configure#automake('nrwi')
augroup END

" Python config
augroup filetype_python
	autocmd!
	autocmd FileType python set smarttab
	autocmd FileType python set smartindent
augroup END

" JavaScript config
augroup filetype_js
	autocmd!
	autocmd FileType javascript set expandtab
	autocmd FileType javascript set tabstop=2
	autocmd FileType javascript set softtabstop=2
	autocmd FileType javascript set shiftwidth=2
	autocmd FileType javascript set smarttab
 	autocmd FileType javascript nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

" TypeScript config
augroup filetype_ts
	autocmd!
	autocmd FileType typescript set expandtab
	autocmd FileType typescript set tabstop=2
	autocmd FileType typescript set softtabstop=2
	autocmd FileType typescript set shiftwidth=2
	autocmd FileType typescript set smarttab
 	autocmd FileType typescript nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

" JavaScript React config
augroup filetype_javascriptreact
	autocmd!
	autocmd FileType javascriptreact set expandtab
	autocmd FileType javascriptreact set tabstop=2
	autocmd FileType javascriptreact set softtabstop=2
	autocmd FileType javascriptreact set shiftwidth=2
	autocmd FileType javascriptreact set smarttab
 	autocmd FileType javascriptreact setlocal formatoptions+=r
 	autocmd FileType javascriptreact nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

" TypeScript React config
augroup filetype_typescriptreact
	autocmd!
	autocmd FileType typescriptreact set expandtab
	autocmd FileType typescriptreact set tabstop=2
	autocmd FileType typescriptreact set softtabstop=2
	autocmd FileType typescriptreact set shiftwidth=2
	autocmd FileType typescriptreact set smarttab
 	autocmd FileType typescriptreact setlocal formatoptions+=r
 	autocmd FileType typescriptreact nnoremap <leader>jp :CocCommand prettier.formatFile<CR>
augroup END

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

" Shell script config
 augroup filetype_sh
	autocmd!
	autocmd FileType sh call neomake#configure#automake('nrwi')
 augroup END

" Neomake PHP config
let g:neomake_php_phpcs_args_standard = 'PSR2'
let g:neomake_php_enabled_makers = ['phpmd', 'phpcs', 'phpstan', 'php']

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
