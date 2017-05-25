let g:vimwiki_folding='list'

" If configured, use Dropbox for vimwiki
if "g:dotfiles_vimwiki_dropbox" && g:dotfiles_vimwiki_dropbox
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki'}]
endif

:map <Leader>tt <Plug>VimwikiToggleListItem
