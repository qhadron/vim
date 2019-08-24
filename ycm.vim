function s:check_ycm_deps()
	" dict of executable: package
	"   python3 to run the install script
	"   cmake for the make files
	"   python3-config for python headers ("python3-dev" package)
	"   c++, cc for cxx, c compiler ("build-essential" package)
	let deps = { 
				\'python3': 'python3',
				\'cmake': 'cmake',
				\'python3-config': 'python3-dev',
				\'c++': 'build-essential',
				\'cc': 'build-essential', 
				\ }
	let missing = {}
	for dep in keys(deps)
		if !executable(dep)
			let missing[deps[dep]]=1
		endif
	endfor
	if len(missing) > 0
		augroup s:ycm_warning
			autocmd!
			execute "autocmd VimEnter * echom 'Install ".join(keys(missing), ', ')." to enable YouCompleteMe.' | autocmd! s:ycm_warning"
		augroup END
		return 0
	else
		return 1
	endif
endfunction

" check dependencies and add them as flags	
function s:get_ycm_flags()
	" filetypes to load ycm for on insert (use mapping for performance)
	let g:ycm_filetypes = {'cpp':1, 'c':1, 'python':1 }

	" clang(d) completer is free since ycm downloads it
	let ycm_flags = [ '--clang-completer', '--clangd-completer' ]
	if executable('xbuild')
		let ycm_flags += [ '--cs-completer' ]
		let g:ycm_filetypes['cs']=1
	endif
	if executable('go')
		let ycm_flags += [ '--go-completer' ]
		let g:ycm_filetypes['go']=1
	endif
	if executable('tsserver') || (executable('node') && executable('npm'))
		let ycm_flags += [ '--ts-completer' ]
		let g:ycm_filetypes['javascript']=1
		let g:ycm_filetypes['typescript']=1
	endif
	if executable('javac')
		let ycm_flags += [ '--java-completer' ]
		let g:ycm_filetypes['java']=1
		let g:ycm_filetypes['javacc']=1
	endif
	if executable('rustc')
		let ycm_flags += [ '--rust-completer' ]
		let g:ycm_filetypes['rust']=1
	endif
	return ycm_flags
endfunction

function s:check_load_ycm()
	if get(g:ycm_filetypes, &filetype, 0)
		call plug#load('YouCompleteMe')
		autocmd! load_ycm
	endif
endfunction

function g:PlugYcm()
	if s:check_ycm_deps()

		let flags=s:get_ycm_flags()

		" completion (don't use 'for':[...] here to load on insert)
		Plug 'Valloric/YouCompleteMe', { 
					\ 'on': [] ,
					\ 'do': 'python3 ./install.py '.join(flags)
					\}
		
		" command to enable YCM (triggers vim-plug)
		command! YCM call plug#load('YouCompleteMe')

		" load ycm when it's needed
		augroup load_ycm
			autocmd!
			autocmd InsertEnter * call s:check_load_ycm()
		augroup END

	endif
endfunction
