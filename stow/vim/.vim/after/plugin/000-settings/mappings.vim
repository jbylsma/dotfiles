" Underline the current line with '='
nnoremap <silent> <leader>ul :t.<CR>Vr=

" Map the arrow keys to be based on display lines, not physical lines,
" unless given a count
noremap <expr> <Down> v:count ? 'j' : 'gj'
noremap <expr> <Up> v:count ? 'k' : 'gk'

" Accept the highlighted completion match with Enter. endwise and eunuch
" map <CR> in a way that closes the menu without inserting the match; they
" wrap this mapping at VimEnter, so their behavior is kept.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Fix arrow keys under screen-* terms
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Open a shell in a split, starting in the current file's path
if has('terminal')
  nnoremap <silent> <leader>sh
        \ :call term_start(&shell,
        \ {'cwd': expand('%:p:h'), 'term_finish': 'close'})<CR>
endif

" After whitespace, insert the current directory into a command-line path
cnoremap <expr> <C-P> getcmdline()[getcmdpos()-2] ==# ' ' ? expand('%:p:h') : "\<C-P>"
