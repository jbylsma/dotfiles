set number
set modeline
set hidden
set visualbell

set splitbelow
set splitright

" Use low updatetime to trigger CursorHold faster
set updatetime=100

" Whitespace
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set list

" Searching
set hlsearch
set ignorecase
set smartcase

" If available, use Ripgrep or Silver Searcher for :grep
if executable('rg')
  set grepprg=rg\ --vimgrep grepformat=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --vimgrep grepformat=%f:%l:%c:%m
endif

" Open the quickfix window after :grep, :make and similar commands
augroup vimrc_quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

" Folding
set nofoldenable
set foldmethod=indent

" Wild settings (cmdline-completion)
" Show matches in a popup menu where supported, otherwise list them
if has('patch-8.2.4325')
  set wildmode=longest:full,full
  set wildoptions=pum
else
  set wildmode=longest,list
endif
set wildignore+=tags
set wildignore+=*.swp,*~,._*

" Insert mode completion (ins-completion)
set completeopt=menu,menuone,preview
if version > 704
  set completeopt+=noselect
else
  set completeopt+=longest
endif
if has('patch-8.1.1880')
  set completeopt-=preview completeopt+=popup
endif

" Diff
" Older Vims reject these values and leave diffopt unchanged
silent! set diffopt+=algorithm:histogram,indent-heuristic
silent! set diffopt+=linematch:60

" ctags
" tags;$HOME will search for tags recursively until $HOME
set tags=./tags,tags;$HOME

" Backup, swap and undo files
if !isdirectory($HOME . '/.vim/_backup')
  call mkdir($HOME . '/.vim/_backup', 'p')
endif
set backupdir^=~/.vim/_backup//

if !isdirectory($HOME . '/.vim/_temp')
  call mkdir($HOME . '/.vim/_temp', 'p')
endif
set directory^=~/.vim/_temp//

if !isdirectory($HOME . '/.vim/_undo')
  call mkdir($HOME . '/.vim/_undo', 'p')
endif
set undodir=~/.vim/_undo//
set undofile

" GUI
if has("gui_running") && has("autocmd")
  " Automatically resize splits when resizing MacVim window
  augroup vimrc_resize
    autocmd!
    autocmd VimResized * wincmd =
  augroup END
endif
