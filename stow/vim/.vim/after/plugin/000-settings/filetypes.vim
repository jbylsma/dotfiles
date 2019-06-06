" Include man filetype plugin
runtime! ftplugin/man.vim

" PHP
" Use PHP syntax with Drupal files
au BufNewFile,BufRead *.install set filetype=php
au BufNewFile,BufRead *.test set filetype=php
au BufNewFile,BufRead *.inc set filetype=php

" Apache
" Use indent from apachestyle
autocmd FileType apache exe 'runtime! indent/apachestyle.vim'

" Set default indentation based on stock Apache conf
au FileType apache setlocal tabstop=4 softtabstop=0 shiftwidth=4 expandtab
