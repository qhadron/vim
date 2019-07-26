" start plugin list
call plug#begin($VIM_PREFIX . '/plugged')

	""""""""""""""""""""""""""""""
	" => Visual
	""""""""""""""""""""""""""""""

	" colours
	Plug 'flazz/vim-colorschemes'	

	" status line
	Plug 'itchyny/lightline.vim'

	" zen mode
	Plug 'junegunn/goyo.vim'

	" colored parentheses
	Plug 'luochen1990/rainbow'

	""""""""""""""""""""""""""""""
	" => Navigation
	""""""""""""""""""""""""""""""

	" fzf (fuzzy file searcher)
	" binary
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all;git reset --hard; git apply '.$VIM_PREFIX.'/patches/0001-add-prefer-term-option-for-vim.patch' }
	" vim configs (provides Ack functionality too)
	Plug 'junegunn/fzf.vim'

	" buffer manager
	Plug 'jlanzarotta/bufexplorer'

	" better motions (f,t)
	Plug 'easymotion/vim-easymotion'

	" NERD tree will be loaded on the first invocation of NERDTreeToggle command
	Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle'] }

	" Similarly, load NERDTree git status plugin
	Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle'] }

	""""""""""""""""""""""""""""""
	" => Editing
	""""""""""""""""""""""""""""""

	" surround text with stuff
	Plug 'tpope/vim-surround'

	" pairs of actions (insert blank line, switch lines, etc)
	Plug 'tpope/vim-unimpaired'
			
	" repeat plugin commands (vim-surround)
	Plug 'tpope/vim-repeat'

	" make <C-A>, <C-X> work with dates
	Plug 'tpope/vim-speeddating'

	" clipboard manager
	Plug 'svermeulen/vim-yoink'
	" substitute/modify text with clipboard
	Plug 'svermeulen/vim-subversive'

	" pop-up window to show registers
	Plug 'junegunn/vim-peekaboo'

	" alignment (used with markdown for formatting tables
	Plug 'godlygeek/tabular'

	""""""""""""""""""""""""""""""
	" => syntax support
	""""""""""""""""""""""""""""""

	" syntax checking
	Plug 'vim-syntastic/syntastic'

	" markdown support
	Plug 'plasticboy/vim-markdown'

	""""""""""""""""""""""""""""""
	" => Git
	""""""""""""""""""""""""""""""

	" git
	Plug 'tpope/vim-fugitive'

	" git diff
	Plug 'airblade/vim-gitgutter'

	""""""""""""""""""""""""""""""
	" => Programming
	""""""""""""""""""""""""""""""

	" snippet manager
	Plug 'SirVer/ultisnips', { 'on': [] }
	" snippets for the manager
	Plug 'honza/vim-snippets', { 'on': [] }

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

	if s:check_ycm_deps()
		" completion (don't use 'for':[...] here to load on insert
		Plug 'Valloric/YouCompleteMe', { 
					\ 'on': [] ,
					\ 'do': 'python3 ./install.py --clang-completer' 
					\}

		" command to enable YCM (triggers vim-plug)
		command! YCM call plug#load('YouCompleteMe')

		" filetypes to load ycm for on insert (use mapping for performance)
		let g:ycm_filetypes = {'js':1, 'cpp':1, 'c':1, 'python':1 }
		
		function s:check_load_ycm()
			if get(g:ycm_filetypes, &filetype, 0)
				call plug#load('YouCompleteMe')
				autocmd! load_ycm
			endif
		endfunction

		" load ycm when it's needed
		augroup load_ycm
		  autocmd!
		  autocmd InsertEnter * call s:check_load_ycm()
		augroup END
	endif

	" load snippets when it's needed
	augroup load_snippets
		autocmd!
		autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets') 
					\| autocmd! load_snippets
	augroup END




call plug#end()
