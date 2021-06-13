source $HOME/.vimrc

" Enable console dialogs. Disable the toolbar and GUI tabs.
set guioptions+=c
set guioptions-=e
set guioptions-=T

if filereadable(expand("~/.gvimrc.local"))
  source ~/.gvimrc.local
endif
