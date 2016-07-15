" Theme
set background=dark
colorscheme molokai

" 2015-02-16
" Turn on visual bell
set visualbell

" 2015-02-12
" Split nicely
set splitbelow
set splitright

" Make ctags search recursively
set tags=./tags,tags;$HOME

" Override gundo mapping with vdebug
if (exists("*Vdebug_load_keymaps"))
  call Vdebug_load_keymaps(g:vdebug_keymap)
  let vdebug_options['break_on_open'] = 0
endif

"Disable aggressive PHP checking
" let g:syntastic_phpcs_disable=1
let g:syntastic_php_checkers=['php']
let g:syntastic_php_checkers=['php', 'phpmd']

"Use PHP syntax with files
au BufNewFile,BufRead *.install set filetype=php
au BufNewFile,BufRead *.test set filetype=php
au BufNewFile,BufRead *.inc set filetype=php

" 2014-08-30
" Janus uses :NERDTreeMirror whenever NT is invoked. Override.
map <Leader>n :NERDTree<CR>

" 2016-05-05
" Ignore ctags files
set wildignore+=tags

" 2016-06-02
" Include man filetype plugin
runtime! ftplugin/man.vim

" 2016-07-07
" Ack: Don't switch to first result, use Ag
cnoreabbrev Ack Ack!

if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif