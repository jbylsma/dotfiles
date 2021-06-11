set number
set modeline
set hidden
set visualbell

set splitbelow
set splitright

" Use low updatetime to trigger CursorHold faster
set updatetime=100

" Theme
set background=dark
let g:molokai_original=1
let g:rehash256 = 1
silent! colorscheme molokai

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

" Folding
set nofoldenable
set foldmethod=indent

" Wild settings (cmdline-completion)
set wildmode=longest,list
set wildignore+=tags
set wildignore+=*.swp,*~,._*

" Insert mode completion (ins-completion)
set completeopt=menu,menuone,preview
if version > 704
  set completeopt+=noselect
else
  set completeopt+=longest
endif

" ctags
" tags;$HOME will search for tags recursively until $HOME
set tags=./tags,tags;$HOME

" Backup and swap files
set backupdir^=~/.vim/_backup//
set directory^=~/.vim/_temp//

" GUI
if has("gui_running") && has("autocmd")
  " Automatically resize splits when resizing MacVim window
  autocmd VimResized * wincmd =
endif
