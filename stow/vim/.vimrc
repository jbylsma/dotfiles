let mapleader = ' '

" If available, use Ag
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Override UltiSnips mappings
let g:UltiSnipsListSnippets='<s-tab>'

" Last chance to override things
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" Use 24-bit colors
" Reference termguicolors and xterm-true-color
if has('termguicolors') && !has('gui_running')
  set termguicolors
  if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
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
Plug 'fatih/molokai'

" Languages
Plug 'vim-scripts/apachestyle'
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
Plug 'chikamichi/mediawiki.vim'

" Plugins
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
Plug 'thinca/vim-visualstar'
Plug 'sh-dude/ZoomWin'
Plug 'rizzatti/dash.vim'
Plug 'godlygeek/tabular'
Plug 'joonty/vdebug', { 'on': 'VdebugOn' }
command! VdebugOn call plug#load('vdebug')
Plug 'bling/vim-airline'
Plug 'junegunn/gv.vim'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/vim-peekaboo'
Plug 'wesQ3/vim-windowswap'

call plug#end()

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
