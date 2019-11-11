set encoding=utf-8
scriptencoding utf-8
set background=dark
let g:is_bash = 1

if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config//nvim/autoload/plug.vim --create-dirs
           \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    augroup PLUG
        au!
        autocmd VimEnter * PlugInstall
    augroup END
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'terryma/vim-multiple-cursors'
    let g:multi_cursor_use_default_mapping=0
    let g:multi_cursor_next_key='<C-j>'
    let g:multi_cursor_prev_key='<C-k>'
    let g:multi_cursor_skip_key='<C-s>'
    let g:multi_cursor_quit_key='<Esc>'

Plug 'w0rp/ale'
    let g:ale_sign_column_always = 1
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_fix_on_save = 1

Plug 'dylanaraps/wal.vim'
Plug 'scrooloose/nerdtree'
Plug 'nerdypepper/vim-colors-plain', { 'branch': 'duotone' }
Plug 'godlygeek/tabular'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'aesophor/base16-faded'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'terryma/vim-expand-region'
	vmap v <Plug>(expand_region_expand)
	vmap <C-v> <Plug>(expand_region_shrink)

Plug 'mzlogin/vim-markdown-toc'
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
	nmap ss ysiw
	nmap sl yss
	vmap s S

call plug#end()
filetype plugin on

syntax on
set t_Co=256
colorscheme base16-faded

cmap w!! w !sudo tee % >/dev/null
cnoreabbrev q qa
nmap az za
nnoremap <S-Tab> :bp<CR>
nnoremap <Tab> :bn<CR>
nnoremap H 0
nnoremap L A
nnoremap j gj
nnoremap k gk
noremap ; :
vmap <BS> <gv
vmap <TAB> >gv
vnoremap H 0
vnoremap L $
vnoremap j gj
vnoremap k gk
xnoremap p pgvy

set signcolumn=yes
set noshowmode
set laststatus=0
set synmaxcol=150
set shortmess=atI
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set breakindent
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
set re=1
set foldmethod=marker
set foldlevel=99
set foldlevelstart=0
set hlsearch
set incsearch
set ignorecase
set smartcase
set undofile
set undolevels=1000
set undoreload=1000
set autochdir
set clipboard=unnamedplus
set nostartofline
set notimeout
set nottimeout
set nrformats-=octal
set modeline
set backspace=indent,eol,start
set noswapfile
set backupdir=~/.config/nvim/tmp/backups/
set undodir=~/.config/nvim/tmp/undo/

if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), 'p')
endif

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
endif

augroup General
    au!
    autocmd FileType markdown,text setlocal spell
    autocmd FileType * setlocal formatoptions-=cro
    autocmd FileType xdefaults setlocal commentstring=!\ %s
    autocmd FileType scss,css  setlocal shiftwidth=2 softtabstop=2

    autocmd BufWritePre [:;]* throw 'Forbidden file name: ' . expand('<afile>')
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

let g:currentmode={
			\ 'n'  : 'NORMAL ',
			\ 'no' : 'N·OPERATOR PENDING ',
			\ 'v'  : 'VISUAL ',
			\ 'V'  : 'V·LINE ',
			\ '' : 'V·BLOCK ',
			\ 's'  : 'SELECT ',
			\ 'S'  : 'S·LINE ',
			\ '' : 'S·BLOCK ',
			\ 'i'  : 'INSERT ',
			\ 'R'  : 'REPLACE ',
			\ 'Rv' : 'V·REPLACE ',
			\ 'c'  : 'COMMAND ',
			\ 'cv' : 'VIM EX ',
			\ 'ce' : 'EX ',
			\ 'r'  : 'PROMPT ',
			\ 'rm' : 'MORE ',
			\ 'r?' : 'CONFIRM ',
			\ '!'  : 'SHELL ',
			\ 't'  : 'TERMINAL '}

" Function: return current mode
" abort -> function will abort soon as error detected
function! ModeCurrent() abort
	let l:modecurrent = mode()
	" use get() -> fails safely, since ^V doesn't seem to register
	" 3rd arg is used when return of mode() == 0, which is case with ^V
	" thus, ^V fails -> returns 0 -> replaced with 'V Block'
	let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
	let l:current_status_mode = l:modelist
	return l:current_status_mode
endfunction

hi PrimaryBlock        ctermfg=00 ctermbg=03
hi SecondaryBlock      ctermfg=00 ctermbg=05
hi Blanks              ctermfg=00 ctermbg=04
highlight EndOfBuffer ctermfg=black ctermbg=black

set statusline=
set statusline+=%#PrimaryBlock#
set statusline+=\ %{ModeCurrent()}
set statusline+=%#SecondaryBlock#
set statusline+=%{StatuslineGit()}
set statusline+=%#Blanks#
set statusline+=\ %t
set statusline+=%(%m%)
set statusline+=%=
set statusline+=%#SecondaryBlock#
set statusline+=\ Ln
set statusline+=\ %l
set statusline+=,Col
set statusline+=\ %c
set statusline+=%#PrimaryBlock#
set statusline+=\ %Y

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" nerdtree
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeWinPos              = 'left'
let g:NERDTreeWinSize             = 20
let g:NERDTreeStatusline          = "  "
let g:NERDTreeDirArrowExpandable  = '+'
let g:NERDTreeDirArrowCollapsible = '-'
