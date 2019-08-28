" remember fzf mode or not when cycling
let g:fzf_cycle_remember_mode=1

" default fzf cycle function names or function refs
let g:fzf_cycle_commands = ['fzf#vim#buffers', 'fzf#vim#files']
" add more commands like this:
" let g:fzf_cycle_commands += [function('s:find_all_files')]


" fzf mode index of commands array
let s:fzf_cycle_index=0

let s:has_timers=has('timers')

" fzf mapping to switch search type
" https://github.com/junegunn/fzf.vim/issues/289#issuecomment-447560813
function! s:fzf_cycle(idx)
	let idx=a:idx
	let s:fzf_cycle_prompt_len=0
	let command = type(g:fzf_cycle_commands[idx]) == type("") ?
				\ g:fzf_cycle_commands[idx] :
				\ string(g:fzf_cycle_commands[idx])
	" start fzf
	execute 'call '.command.'("", fzf#vim#with_preview('.string(g:fzf_layout).', "right:hidden", "?"), 0)'
	" check fzf prompt length
	if s:has_timers
		call timer_start(10, function('s:fzf_get_prompt'), {'repeat': -1})
	else
		sleep 100m
		call s:fzf_get_prompt(0)
	endif
	execute 'tnoremap <buffer> <silent> <c-f> <c-\><c-n>:silent call <sid>fzf_cycle_next_mode('.idx.')<cr>'
endfunction

" 1. check if fzf started (prompt len > 0)
" 2. get the prompt length
" 3. insert any previous input
function! s:fzf_get_prompt(timerid)
	let col=term_getcursor('')[1]-1
	let s:fzf_cycle_prompt_len=strchars(strcharpart(term_getline("","."),0,col))
	if s:fzf_cycle_prompt_len
		if s:has_timers
			call timer_stop(a:timerid)
		endif
		if exists('s:fzf_cycle_user_text')
			call feedkeys(s:fzf_cycle_user_text, "n")
		endif
	endif
endfunction

" 1. get the user input minus fzf's prompt
" 2. close the fzf window
" 3. open next fzf mode
function! s:fzf_cycle_next_mode(idx)
	" get user entered text before exiting
	let col=term_getcursor('')[1] - 1 " -1 because col is 1 based
	let s:fzf_cycle_user_text=strcharpart(term_getline("","."), s:fzf_cycle_prompt_len, col-s:fzf_cycle_prompt_len)

	close!
	" needed for focus reasons
	sleep 1m

	" remember the current index
	let s:fzf_cycle_index = (a:idx + 1) % len(g:fzf_cycle_commands)
	call s:fzf_cycle(s:fzf_cycle_index)
endfunction

command! FZFCycle let s:fzf_cycle_user_text="" | call <sid>fzf_cycle(
			\ g:fzf_cycle_remember_mode ?  s:fzf_cycle_index : 0
			\ )
