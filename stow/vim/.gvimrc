if filereadable(expand("~/.gvimrc.before"))
  source ~/.gvimrc.before
endif

" Enable console dialogs. Disable the toolbar and GUI tabs.
set guioptions+=c
set guioptions-=e
set guioptions-=T

source ~/.vimrc

if filereadable(expand("~/.gvimrc.after"))
  source ~/.gvimrc.after
endif
