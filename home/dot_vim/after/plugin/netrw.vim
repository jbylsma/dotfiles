" Toggle a tree-style netrw sidebar via :Lexplore, overriding a few
" netrw globals only while the sidebar is opening and restoring the
" prior values afterward so vim-vinegar's `-` pop-in keeps whatever
" settings were in effect before.
"
" If a var was unset before the toggle ran (netrw sets some globals
" lazily in its autoload, so they may not exist until first use), we
" restore it to netrw's documented default rather than :unlet-ing it
" --- netrw's internals reference these without exists() checks and
" will E121 if we leave them undefined.
function! s:ToggleTreeSidebar() abort
  let l:overrides = {
        \ 'netrw_liststyle': 3,
        \ 'netrw_browse_split': 4,
        \ 'netrw_winsize': 20,
        \ 'netrw_altv': 1,
        \ }

  let l:defaults = {
        \ 'netrw_liststyle': 0,
        \ 'netrw_browse_split': 0,
        \ 'netrw_winsize': 50,
        \ 'netrw_altv': 0,
        \ }

  let l:saved = {}
  for l:var in keys(l:overrides)
    let l:saved[l:var] = exists('g:' . l:var)
          \ ? get(g:, l:var)
          \ : l:defaults[l:var]
  endfor

  for [l:var, l:val] in items(l:overrides)
    execute 'let g:' . l:var . ' = ' . string(l:val)
  endfor

  Lexplore

  for [l:var, l:val] in items(l:saved)
    execute 'let g:' . l:var . ' = ' . string(l:val)
  endfor
endfunction

nnoremap <silent> <leader>e :call <SID>ToggleTreeSidebar()<CR>
