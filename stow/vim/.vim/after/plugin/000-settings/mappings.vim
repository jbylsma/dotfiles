" Underline the current line with '='
nmap <silent> <leader>ul :t.<CR>Vr=

" Map the arrow keys to be based on display lines, not physical lines
map <Down> gj
map <Up> gk

" Fix arrow keys under screen-* terms
if &term =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Open up a shell starting in the current file's path
noremap zz :execute '!cd ' . shellescape(expand("%:p:h")) . ' && ' . &shell <CR>

" After whitespace, insert the current directory into a command-line path
cnoremap <expr> <C-P> getcmdline()[getcmdpos()-2] ==# ' ' ? expand('%:p:h') : "\<C-P>"
