if exists('g:CSApprox_loaded')
  " Force CSApprox to process all schemes, not just <16 color ones
  augroup CSApprox
    au!
    au ColorScheme * CSApprox!
  augroup END
endif
