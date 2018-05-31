let mapleader = ' '

" If available, use Ag
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Override UltiSnips mappings
let g:UltiSnipsListSnippets='<s-tab>'

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" Automatically install VimPlug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" VimPlug has been locking up over SSH connections, so try a lower thread
let g:plug_threads = 8
call plug#begin('~/.vim/plugged')

" Colors
Plug 'tomasr/molokai'

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
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'terryma/vim-multiple-cursors'
Plug 'chrisbra/NrrwRgn'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'scrooloose/syntastic', { 'on': 'SyntasticOn' }
command! SyntasticOn call plug#load('syntastic')
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'thinca/vim-visualstar'
Plug 'sh-dude/ZoomWin'
Plug 'rizzatti/dash.vim'
Plug 'chikamichi/mediawiki.vim'
Plug 'godlygeek/tabular'
Plug 'joonty/vdebug', { 'on': 'VdebugOn' }
command! VdebugOn call plug#load('vdebug')
Plug 'bling/vim-airline'
Plug 'int3/vim-extradite'
Plug 'kshenoy/vim-signature'

" ultisnips requires Python, but there's no reason to load vim-snippets
" without ultisnips
if has('python')
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
endif

call plug#end()

" Theme
set background=dark
let g:rehash256 = 1
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

" Include man filetype plugin
runtime! ftplugin/man.vim

" Set up default folding, but don't fold by default
" foldmethod=syntax is too slow for large files
set foldmethod=indent
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

" Set up better tab completion
set wildignore+=tags
set wildmode=longest,list

set completeopt=menu,menuone,preview
if version > 704
  set completeopt+=noselect
else
  set completeopt+=longest
endif

" Open up a shell starting in the current file's path
:noremap zz :execute '!cd ' . shellescape(expand("%:p:h")) . ' && ' . &shell <CR>

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
