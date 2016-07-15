source $HOME/.vimrc

" Enable console dialogs. Disable the toolbar and GUI tabs.
set guioptions+=c
set guioptions-=e
set guioptions-=T

" Font
set guifont=Ubuntu\ Mono\ 16

if has("gui_macvim")
  set guifont=Ubuntu_Mono:h18
endif

" Set a nice theme
let g:molokai_original=1
colo molokai

if filereadable(expand("~/.gvimrc.after.local"))
  source ~/.gvimrc.local
endif