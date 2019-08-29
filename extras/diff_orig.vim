" add a :DiffOrig command to compare unsaved changes with filesystem version
" see :help :DiffOrig for inspiration

" a lot of the following code is taken from vim-fugitive plugin's diff
" implementation

function! s:can_diffoff(buf) abort
  return getwinvar(bufwinnr(a:buf), '&diff') &&
        \ !empty(getwinvar(bufwinnr(a:buf), 'diff_orig'))
endfunction

function! s:diffoff()
	if exists('w:diff_orig')
		execute w:diff_orig
		unlet w:diff_orig
	else
		diffoff
	endif
endfunction

function! s:diffoff_all() abort
  let curwin = winnr()
  for nr in range(1,winnr('$'))
    if getwinvar(nr,'&diff')
      if nr != winnr()
        execute nr.'wincmd w'
      endif
	  call s:diffoff()
    endif
  endfor
  execute curwin.'wincmd w'
endfunction

augroup diff_orig
	autocmd!
	  autocmd BufWinLeave *
        \ if s:can_diffoff(+expand('<abuf>')) && s:diff_window_count() == 2 |
		\   call s:diffoff_all() |
        \ endif
  autocmd BufWinEnter *
        \ if s:can_diffoff(+expand('<abuf>')) && s:diff_window_count() == 1 |
        \   call s:diffoff() |
		\ endif
augroup END

function! s:diff_window_count() abort
  let c = 0
  for nr in range(1,winnr('$'))
    let c += getwinvar(nr,'&diff')
  endfor
  return c
endfunction

function! s:diff_restore() abort
  let restore = 'setlocal nodiff noscrollbind'
        \ . ' scrollopt=' . &l:scrollopt
        \ . (&l:wrap ? ' wrap' : ' nowrap')
        \ . ' foldlevel=999'
        \ . ' foldmethod=' . &l:foldmethod
        \ . ' foldcolumn=' . &l:foldcolumn
        \ . ' foldlevel=' . &l:foldlevel
        \ . (&l:foldenable ? ' foldenable' : ' nofoldenable')
  if has('cursorbind')
    let restore .= (&l:cursorbind ? ' ' : ' no') . 'cursorbind'
  endif
  return restore
endfunction

function! s:diff_orig()
	if filereadable(expand('%'))
		" save filetype
		let ft=&filetype
		let name=@%

		" get a command to go back (from fugitive.vim)
		let back = exists('*win_getid') ? 'call win_gotoid(' . win_getid() . ')' : 'wincmd p'

		" create new window with buffer type 'nofile'
		vertical new

		" paste contents of target file and delete extra line
		r ++edit #
		0d_

		" set some options for the new buffer
		setlocal buftype=nofile readonly nobuflisted bufhidden=wipe
		nnoremap <silent> <buffer> q :bdelete<cr>
		execute 'setfiletype '.ft
		silent! 0file!
		silent! execute "silent! file [fs ver] ".name

		" diff the files
		if !&diff
			let w:diff_orig = s:diff_restore()
			diffthis
		endif
		execute back
		if !&diff
			let w:diff_orig = s:diff_restore()
			diffthis
		endif
	endif
endfunction

command DiffOrig call s:diff_orig()
