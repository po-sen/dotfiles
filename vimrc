call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0

Plug 'bfrg/vim-cpp-modern'
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight     = 1
let g:cpp_simple_highlight     = 1

Plug 'chr4/nginx.vim'

Plug 'ervandew/supertab'
let g:SuperTabCrMapping             = 1
" let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabLongestHighlight      = 1
let g:SuperTabMidWordCompletion     = 0

Plug 'junegunn/fzf', { 'do': './install --all' }

Plug 'junegunn/fzf.vim'

Plug 'junegunn/vim-easy-align'

Plug 'martinda/Jenkinsfile-vim-syntax'

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
let g:undotree_WindowLayout = 2

Plug 'mhinz/vim-startify'

Plug 'neoclide/jsonc.vim'

Plug 'pangloss/vim-javascript'

Plug 'plasticboy/vim-markdown'
let g:vim_markdown_conceal             = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled    = 1

Plug 'preservim/nerdtree'
let NERDTreeWinSize = 30
let NERDTreeWinPos  = 'right'

Plug 'tomasr/molokai'
let g:molokai_original = 1
let g:rehash256        = 1

Plug 'towolf/vim-helm'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
let g:airline_extensions                           = ['branch', 'tabline']
let g:airline#extensions#tabline#enabled           = 1
let g:airline#extensions#tabline#fnamemod          = ':t'
let g:airline#extensions#tabline#left_alt_sep      = ''
let g:airline#extensions#tabline#left_sep          = ''
let g:airline#extensions#tabline#show_buffers      = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_splits       = 0
let g:airline#extensions#tabline#show_tab_nr       = 0
let g:airline#extensions#tabline#show_tab_type     = 0
let g:airline#extensions#tabline#tab_min_count     = 2
let g:airline_section_x                            = "%{col('.')}/%{col('$')-1} @ %l/%L"
let g:airline_section_y                            = "%{&filetype}"
let g:airline_section_z                            = "%{strftime('%Y-%m-%d %H:%M')}"
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'

Plug 'vim-airline/vim-airline-themes'
let g:airline_theme = 'molokai'

Plug 'vim-python/python-syntax'
let g:python_highlight_all = 1

Plug 'Yggdroot/indentLine'
let g:indentLine_char_list    = ['|', '¦', '┆', '┊']
let g:indentLine_color_term   = 239
let g:indentLine_enabled      = 1
" let g:indentLine_setConceal   = 0
let g:markdown_syntax_conceal = 0
let g:vim_json_conceal        = 0

call plug#end()

silent! colorscheme molokai

set autochdir
set autoindent
set background=dark
set backspace=2
set cursorline
set encoding=utf-8
set expandtab
set fileformat=unix
set hlsearch
set ic
set incsearch
set list
set listchars=tab:├─,trail:.,extends:»,precedes:«,nbsp:×
set mouse=vi
set nowrap
set noshowmode
set number
set re=0
set scrolloff=1
set shiftwidth=4
set showmatch
set sidescroll=1
set softtabstop=4
set tabstop=4
set timeoutlen=1000
set ttimeoutlen=0

if has('termguicolors')
  set termguicolors
endif

nnoremap <F1> :PlugUpgrade<cr>:PlugStatus<cr>
nnoremap <F2> :PlugUpgrade<cr>:PlugClean!<cr>

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

nmap <leader>] <Plug>(GitGutterNextHunk)
nmap <leader>[ <Plug>(GitGutterPrevHunk)
nmap gu <Plug>(GitGutterUndoHunk)
nmap gi <Plug>(GitGutterStageHunk)

nnoremap U :UndotreeToggle<cr>

nnoremap <tab> :NERDTreeMirror<cr>:NERDTreeToggle<cr>
nnoremap <leader>git :Git
nnoremap <leader><tab> :GFiles<cr>

nnoremap gh :Ghdiffsplit<cr>
nnoremap gv :Gvdiffsplit<cr>
nnoremap gr :Gread<cr>
nnoremap gw :Gwrite<cr>

noremap <s-tab> :'<,'>w !pbcopy<cr><cr>
noremap , <c-e>
noremap ; <c-y>
noremap <leader>, <c-d>
noremap <leader>; <c-u>
noremap <leader><left>  <c-w>h
noremap <leader><down>  <c-w>j
noremap <leader><up>    <c-w>k
noremap <leader><right> <c-w>l
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader><leader> :tabmove -1<cr>

highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
autocmd BufWritePost * GitGutter

autocmd BufWritePre * :%s#\(\n\)\+\%$##e
autocmd BufWritePre * :%s#\s\+$##ge

autocmd BufNewFile,BufRead Dockerfile*  set filetype=dockerfile
autocmd BufNewFile,BufRead gitconfig*   set filetype=gitconfig
autocmd BufNewFile,BufRead Jenkinsfile* set filetype=Jenkinsfile
autocmd BufNewFile,BufRead bash_profile set filetype=sh

autocmd Filetype cpp         setlocal commentstring=//\ %s
autocmd Filetype gitconfig   setlocal commentstring=#\ %s noexpandtab
autocmd Filetype helm        setlocal commentstring=#\ %s softtabstop=2 shiftwidth=2
autocmd Filetype javascript  setlocal commentstring=//\ %s softtabstop=2 shiftwidth=2
autocmd Filetype Jenkinsfile setlocal commentstring=//\ %s softtabstop=2 shiftwidth=2
autocmd Filetype make        setlocal commentstring=#\ %s noexpandtab
autocmd Filetype nginx       setlocal commentstring=#\ %s noexpandtab
autocmd FileType python      setlocal commentstring=#\ %s
autocmd Filetype sql         setlocal commentstring=\--\ %s softtabstop=2 shiftwidth=2
autocmd Filetype toml        setlocal commentstring=#\ %s softtabstop=2 shiftwidth=2
autocmd Filetype typescript  setlocal commentstring=//\ %s softtabstop=2 shiftwidth=2
autocmd Filetype vim         setlocal commentstring=\"\ %s softtabstop=2 shiftwidth=2
autocmd Filetype vue         setlocal commentstring=<!--\ %s\ --> softtabstop=2 shiftwidth=2
autocmd Filetype yaml        setlocal commentstring=#\ %s softtabstop=2 shiftwidth=2
