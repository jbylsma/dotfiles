let g:vimwiki_folding='list'

" Use Dropbox for vimwiki
if exists("g:dotfiles_vimwiki_dropbox") && g:dotfiles_vimwiki_dropbox
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki'}]
endif
