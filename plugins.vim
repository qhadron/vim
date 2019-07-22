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

	" markdown support

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

	" completion
	Plug 'Valloric/YouCompleteMe', { 'on': ['YCM'] , 'do': './install.py --clang-completer' }

	" load snippets when it's needed
	augroup load_snippets
		autocmd!
		autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets') 
					\| autocmd! load_snippets
	augroup END


	" load ycm when it's needed
	augroup load_ycm
	  autocmd!
	  autocmd FileType js,c,cpp,python call plug#load('YouCompleteMe')
						 \| autocmd! load_ycm
	augroup END


call plug#end()
