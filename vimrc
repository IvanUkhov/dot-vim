call pathogen#infect()

mapclear
autocmd!

"-------------------------------------------------------------------------------
" Common
"-------------------------------------------------------------------------------

" Basic
set nocompatible
set encoding=utf-8
set number
set hidden
set history=1000
set backspace=indent,eol,start
set cryptmethod=blowfish
set visualbell
set mouse=a

syntax on
filetype plugin indent on

let mapleader=' '

" Window
nnoremap <C-Up> <C-W>2+
nnoremap <C-Down> <C-W>2-
nnoremap <C-Left> <C-W>2<
nnoremap <C-Right> <C-W>2>

" Interface
set background=light
colorscheme solarized

function! SwitchColorscheme()
  let current = &background

  if current == 'light'
    set background=dark
  else
    set background=light
  endif

  colorscheme solarized
endfunction

nmap <Leader>sc :call SwitchColorscheme()<CR>

let &colorcolumn=81

" Status line
set laststatus=2

set showcmd
set showmode

set statusline=%<%f\ %-4(%m%)%=%-8(%3l,%3c%)

" Searching
set incsearch
set hlsearch
set iskeyword=a-z,A-Z,48-57,_

set ignorecase smartcase

nmap <Leader>si :set ignorecase! \| set ignorecase?<CR>

if executable('ag')
  set grepprg=ag
    \\ --nogroup
    \\ --nocolor
else
  set grepprg=grep
    \\ --binary-files=without-match
    \\ --color=never
    \\ --line-number
    \\ --recursive
    \\ --with-filename
    \\ $*\ ./
endif

command! -nargs=+ -complete=file -bar
  \ Grep silent! grep! '<args>'|cwindow|redraw!

nmap <Leader>g :grep! "\b<C-R><C-W>\b"<CR><CR>:cw<CR>
nmap \ :Grep<SPACE>

" Line wrapping
set nowrap
set linebreak
set showbreak=↪\ "

nmap <Leader>sw :set wrap! list! \| set wrap?<CR>

" Invisible characters
set list
set listchars=tab:▸\ ,trail:•,extends:❯,precedes:❮

function! StripTrailingWhitespace()
  let pattern = @/
  let line = line('.')
  let column = col('.')

  silent! %s/\s\+$//

  let @/ = pattern
  call cursor(line, column)
endfunction

nmap <Leader>cl :call StripTrailingWhitespace()<CR>

" Folding
set foldmethod=indent
set foldnestmax=3
set nofoldenable

" Tab completion
set wildmode=list:longest
set wildmenu
set wildignore=*/.git/*,*/build/*,*.swp,*.swo,*~

" Scrolling
set scrolloff=1
set sidescrolloff=1
set sidescroll=1

" Navigation
set nostartofline

nnoremap zh 5zh
nnoremap zl 5zl

nnoremap <Down> gj
nnoremap <Up> gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <Leader><Leader> <C-^>

nmap <Leader>n :bn<CR>
nmap <Leader>p :bp<CR>
nmap <Leader>d :bn<CR>:bd #<CR>

" Indentation
function! SwitchToTabs()
  set shiftwidth=4
  set softtabstop=0
  set tabstop=4
  set noexpandtab
  set cindent
endfunction

function! SwitchToSpaces()
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set expandtab
  set autoindent
endfunction

call SwitchToSpaces()

" Spell checking
set nospell

nmap <Leader>ss :set spell! \| set spell?<CR>

function! CheckSpelling()
  set spelllang=en_us
  syntax spell toplevel
  set spell
endfunction
autocmd BufEnter *.txt,*.md,*.html,*.tex call CheckSpelling()

" Cursor position
function! RestoreCursorPosition()
  if line("'\"") > 0 && line("'\"") <= line('$')
    exe 'normal! g`"'
    normal! zz
  endif
endfunction
autocmd BufReadPost * call RestoreCursorPosition()

set cursorline

" Editing
set nojoinspaces

nmap <Leader>vi :e $MYVIMRC<CR>
autocmd BufWritePost .vimrc source $MYVIMRC

function! SanitizePath(path)
  return substitute(a:path, ' ', '\\\ ', 'g')
endfunction

function! GetFileDirectory()
  return SanitizePath(expand('%:p:h')) . '/'
endfunction

nmap ,, :e <C-R>=GetFileDirectory()<CR><Space><Backspace>
cmap ,, <C-R>=GetFileDirectory()<CR><Space><Backspace>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . SanitizePath(new_name)
    exec ':silent !rm ' . SanitizePath(old_name)
    redraw!
  endif
endfunction
map <Leader>mv :call RenameFile()<CR>

" Plugins
nmap <Leader>t :NERDTreeToggle<CR>

let g:bufExplorerShowRelativePath = 1
let g:bufExplorerDisableDefaultKeyMapping = 1
nmap <Leader>b :BufExplorerHorizontalSplit<CR>

let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = 'ra'
nmap <Leader>f :CtrlP<CR>
nmap <Leader>rf :CtrlPClearCache<CR>

" Various
nmap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nmap <C-s> :w<CR>
nnoremap Q @@

"-------------------------------------------------------------------------------
" Terminal
"-------------------------------------------------------------------------------

" Input
set ttymouse=xterm2
set t_vb=

"-------------------------------------------------------------------------------
" GUI
"-------------------------------------------------------------------------------

if !has('gui_running')
  finish
end

" Input
set imdisable
set mousemodel=extend

" Window
function! ResizeWindow(...)
  if a:0 > 0
    let lines = a:1
  else
    let lines = &lines
  end

  let columns = 80 + &numberwidth

  if exists('t:NERDTreeBufName')
    if bufwinnr(t:NERDTreeBufName) != -1
      let columns = columns + g:NERDTreeWinSize + 1
    endif
  endif

  execute 'set lines=' . lines . ' columns=' . columns
endfunction
nmap <Leader>rw :call ResizeWindow()<CR>

function! RestoreSession()
  call ResizeWindow(100)

  let file = $HOME . '/.gvimsession'

  if filereadable(file)
    let data = split(readfile(file)[0])
    silent! execute 'winpos ' . data[0] . ' ' . data[1]
  else
    winpos 0 0
  endif
endfunction

function! SaveSession()
  let file = $HOME . '/.gvimsession'
  let data = [
    \ (getwinposx() < 0 ? 0 : getwinposx()) . ' ' .
    \ (getwinposy() < 0 ? 0 : getwinposy()) ]
  call writefile(data, file)
endfunction

autocmd VimEnter * call RestoreSession()
autocmd VimLeavePre * call SaveSession()

" Interface
set guioptions-=T
set guioptions-=m
set guioptions+=b

set linespace=4
if has('mac')
  set guifont=Menlo:h17
else
  set guifont=Monospace\ 11
endif
