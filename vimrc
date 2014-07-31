call pathogen#infect()

" General
set nocompatible
set encoding=utf-8
set hidden
set number
set linespace=4
set history=1000
set cryptmethod=blowfish

syntax on
filetype plugin indent on

" Input
set imdisable
set mouse=a
set ttymouse=xterm2
set backspace=indent,eol,start
set visualbell t_vb=

let mapleader=' '

" Window
nmap + <C-W>2+
nmap - <C-W>2-

" Interface
nmap <Leader>d :set background=dark<CR>
nmap <Leader>l :set background=light<CR>

let g:solarized_termcolors=256
colorscheme solarized
set background=dark

" Status line
set laststatus=2

set showcmd
set showmode

set statusline=%<%f\ %-4(%m%)%=%-8(%3l,%03c%)

" Searching
set incsearch
set hlsearch
set iskeyword=a-z,A-Z,48-57,_

set noignorecase

nmap <Leader>i :set ignorecase<CR>
nmap <Leader>ni :set noignorecase<CR>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  command -nargs=+ -complete=file -bar
    \ Ag silent! grep! <args>|cwindow|redraw!
  nmap \ :Ag<SPACE>
endif

nmap <Leader>g :grep! "\b<C-R><C-W>\b"<CR><CR>:cw<CR>

" Line wrapping
set nowrap
set linebreak
set showbreak=↪\ "

nmap <Leader>w :set wrap<CR>
nmap <Leader>nw :set nowrap<CR>

" Invisible characters
set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

function! StripTrailingWhitespace()
  let l:pattern = @/
  silent! %s/\s\+$//
  let @/ = l:pattern
endfunction

nmap <Leader>c :call StripTrailingWhitespace()<CR>

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Tab completion
set wildmode=list,longest
set wildmenu
set wildignore=*.o,*~

" Scrolling
set scrolloff=1
set sidescrolloff=7
set sidescroll=1

" Navigation
set nostartofline

nmap <Down> gj
nmap <Up> gk

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <Tab> gt
nmap <S-Tab> gT

nmap <Leader><Leader> <C-^>

nmap <Leader>x :w<CR>:bd<CR>
nmap <Leader>j :bn<CR>
nmap <Leader>k :bp<CR>

" Indentation
function! SwitchToTabs()
  set shiftwidth=4
  set softtabstop=0
  set tabstop=4
  set noexpandtab
  set cindent
endfunction
autocmd BufEnter *.js,*.c,*.cpp,*.h,*.hpp call SwitchToTabs()

function! SwitchToSpaces()
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set expandtab
  set autoindent
endfunction
autocmd BufEnter *.rb,*.py,*.tex,*.m call SwitchToSpaces()

call SwitchToSpaces()

" Spell checking
set nospell

nmap <Leader>s :set spell<CR>
nmap <Leader>ns :set nospell<CR>

function! CheckSpelling()
  set spelllang=en_us
  syntax spell toplevel
  set spell
endfunction
autocmd BufEnter *.txt,*.md,*.html,*.tex call CheckSpelling()

" Cursor position
function! RestoreCursorPosition()
  if &filetype !~ 'commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

set cursorline

" Plugins
let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = 'ra'

nmap <Leader>f :CtrlPClearCache<CR>

if has('mac')
  nmap <silent> <D-d> :NERDTreeToggle<CR>
  nmap <silent> <D-x> :BufExplorer<CR>
  nmap <silent> <D-f> :CtrlP<CR>
else
  nmap <silent> <M-d> :NERDTreeToggle<CR>
  nmap <silent> <M-x> :BufExplorer<CR>
  nmap <silent> <M-f> :CtrlP<CR>
endif

" Edit shortcuts
nmap <Leader>c :e ~/.vimrc<CR>

function! GetFileDirectory()
  return substitute(expand("%:p:h"), " ", '\\\ ', "g")
endfunction

nmap ,, :e <C-R>=GetFileDirectory() . "/" <CR><Space><Backspace>
cmap ,, <C-R>=GetFileDirectory() . "/" <CR><Space><Backspace>

" Other shortcuts
nmap <C-s> :w<CR>
nnoremap Q @@
