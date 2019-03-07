let g:vimwiki_folding='list'

:map <Leader>tt <Plug>VimwikiToggleListItem

" If configured, use Dropbox for vimwiki
if exists("g:dotfiles_vimwiki_dropbox")
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/'}]
endif

if has("autocmd")
  au FileType vimwiki setlocal textwidth=80 nolist spell colorcolumn=80
endif

:call vimwiki#vars#init()
