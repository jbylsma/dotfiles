let g:vimwiki_folding='list'

:map <Leader>tt <Plug>VimwikiToggleListItem

if has("autocmd")
  au FileType vimwiki setlocal textwidth=80 nolist spell colorcolumn=80
endif

:call vimwiki#vars#init()
