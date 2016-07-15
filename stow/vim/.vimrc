call plug#begin('~/.vim/plugged')

" Colors
Plug 'vim-scripts/molokai'

" Languages
Plug 'chrisbra/csv.vim'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'mustache/vim-mustache-handlebars'
Plug 'vim-ruby/vim-ruby'
Plug 'cakebaker/scss-syntax.vim'

"Plugins
Plug 'mileszs/ack.vim'
Plug 'ap/vim-css-color'
Plug 'kien/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/NrrwRgn'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'vim-scripts/vimwiki'
Plug 'thinca/vim-visualstar'
Plug 'sh-dude/ZoomWin'

" Non-Janus plugins
Plug 'rizzatti/dash.vim'
" Plug 'sjbach/lusty'
Plug 'chikamichi/mediawiki.vim'
Plug 'godlygeek/tabular'
Plug 'joonty/vdebug'
Plug 'bling/vim-airline'
Plug 'int3/vim-extradite'

call plug#end()

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

set hidden

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
