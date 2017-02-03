let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_by_filename = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']

if g:ctrlp_map != '' && !hasmapto(':<c-u>CtrlPCurWD<cr>', 'n')
  exe 'nn <silent> <Leader>'.g:ctrlp_map ':<c-u>CtrlPCurWD<cr>'
en
