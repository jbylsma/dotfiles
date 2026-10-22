let mapleader = ' '

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

" screen's terminfo doesn't describe italics, so tell Vim how to draw them
if &term =~# '^screen'
  let &t_ZH = "\<Esc>[3m"
  let &t_ZR = "\<Esc>[23m"
endif

" Automatically install VimPlug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Optional packages bundled with Vim; older Vims don't have them
silent! packadd! cfilter
silent! packadd! hlyank

" VimPlug has been locking up over SSH connections, so try a lower thread
let g:plug_threads = 8
call plug#begin('~/.vim/plugged')

" Colors
Plug 'sainnhe/sonokai'

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
Plug 'ap/vim-css-color'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-dispatch'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
if version >= 800
  Plug 'mg979/vim-visual-multi'
endif
Plug 'chrisbra/NrrwRgn'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
if has('timers') && has('job') && has('channel')
  Plug 'dense-analysis/ale'
endif
Plug 'preservim/tagbar'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-vinegar'
Plug 'thinca/vim-visualstar'
Plug 'sh-dude/ZoomWin'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'junegunn/gv.vim'
Plug 'kshenoy/vim-signature'
Plug 'junegunn/vim-peekaboo'
Plug 'wesQ3/vim-windowswap'
Plug 'drmikehenry/vim-fontsize'

call plug#end()

if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif
