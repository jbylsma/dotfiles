autocmd FileType vimwiki setlocal textwidth=80 nolist spell colorcolumn=80
autocmd User vimwiki let g:vimwiki_folding='list'
autocmd User vimwiki map <Leader>tt <Plug>VimwikiToggleListItem

" If configured, use Dropbox for vimwiki
if exists("g:dotfiles_vimwiki_dropbox")
  autocmd User vimwiki let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/'}]
endif

autocmd User vimwiki echom 'Vimwiki has been loaded'
