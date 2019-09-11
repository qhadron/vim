" source YCM configs
source $VIM_PREFIX/extras/ycm.vim

" start plugin list
call plug#begin($VIM_PREFIX . '/plugged')
	""""""""""""""""""""""""""""""
	" => Vim Plug (add help docs)
	""""""""""""""""""""""""""""""
	Plug 'junegunn/vim-plug'

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
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all; git reset --hard origin/master; git apply '.$VIM_PREFIX.'/patches/0001-add-prefer-term-option-for-vim.patch' }
	" vim configs (provides Ack functionality too)
	Plug 'junegunn/fzf.vim', { 'do': 'git reset --hard origin/master; git apply '.$VIM_PREFIX.'/patches/0001-proper-line-handling-for-complete-function.patch' }

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
	" blackhole redirection of delete operations by default
	Plug 'svermeulen/vim-cutlass'

	" pop-up window to show registers
	Plug 'junegunn/vim-peekaboo'

	" alignment (used with markdown for formatting tables)
	Plug 'godlygeek/tabular'

	" emoji support
	Plug 'junegunn/vim-emoji'

	" highlight extra whitespaces
	Plug 'ntpeters/vim-better-whitespace'

	""""""""""""""""""""""""""""""
	" => syntax/filetype support
	""""""""""""""""""""""""""""""

	" syntax checking
	Plug 'vim-syntastic/syntastic'

	" markdown support
	Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

	" mustache/handlebars support
	Plug 'mustache/vim-mustache-handlebars', { 'for': 'mustache' }

	" LaTeX support
	if executable('latexmk')
		Plug 'lervag/vimtex'
	else
		autocmd Filetype tex,plaintex ++once echom 'Install latexmk texlive texlive-latex-extra for tex support!'
	endif

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

	" comment/uncomment with proper escaping
	Plug 'tomtom/tcomment_vim', { 'as': 'tcomment' }

	" call function to plug correct settings for YCM
	call g:PlugYcm()

	" snippet manager
	Plug 'SirVer/ultisnips', { 'on': [] }
	" snippets for the manager
	Plug 'honza/vim-snippets', { 'on': [] }

	" load snippets when it's needed
	augroup load_snippets
		autocmd!
		autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
					\| autocmd! load_snippets
	augroup END

call plug#end()
