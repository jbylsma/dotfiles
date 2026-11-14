" vim-markdown already sets formatoptions+=n and a bullet-aware
" formatlistpat, but without autoindent gq only hangs-indent the first
" wrapped continuation line of a list item, not subsequent ones.
setlocal autoindent

setlocal colorcolumn=80 textwidth=80 spell

" Soft-wrap long lines for on-screen readability without inserting real
" newlines, keeping wrapped display lines indented under the source line.
setlocal wrap linebreak breakindent
