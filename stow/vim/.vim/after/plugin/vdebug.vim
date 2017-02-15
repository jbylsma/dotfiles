autocmd User vdebug silent VdebugOpt break_on_open 0
autocmd User vdebug let g:vdebug_features['max_data'] = -1
autocmd User vdebug let g:vdebug_features['max_children'] = 2048
autocmd User vdebug echom 'Vdebug has been loaded'
