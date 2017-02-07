let mapleader = ' '

" If available, use Ag
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

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
Plug 'joonty/vdebug', { 'on': 'VdebugOn' }
command! VdebugOn  call plug#load('vdebug')
Plug 'bling/vim-airline'
Plug 'int3/vim-extradite'

call plug#end()

" Theme
set background=dark
silent! colorscheme molokai

" 2015-02-16
" Turn on visual bell
set visualbell

" 2015-02-12
" Split nicely
set splitbelow
set splitright

" Make ctags search recursively
set tags=./tags,tags;$HOME

"Use PHP syntax with files
au BufNewFile,BufRead *.install set filetype=php
au BufNewFile,BufRead *.test set filetype=php
au BufNewFile,BufRead *.inc set filetype=php

" 2016-05-05
" Ignore ctags files
set wildignore+=tags

" 2016-06-02
" Include man filetype plugin
runtime! ftplugin/man.vim

" 2016-12-13
" Set up default folding
" http://superuser.com/a/171716/162501
set foldmethod=syntax
set nofoldenable

" Fix arrow keys under screen-* terms
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

set hidden
set modeline

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
