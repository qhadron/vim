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
	Plug 'junegunn/goyo.vim', { 'on': ['Goyo'] }

	" colored parentheses
	Plug 'luochen1990/rainbow'

	""""""""""""""""""""""""""""""
	" => Navigation
	""""""""""""""""""""""""""""""

	" fzf (fuzzy file searcher)
	" binary
	Plug 'junegunn/fzf', {
				\ 'dir': '~/.fzf',
				\ 'do': './install --all;'
				\ }
	" vim configs (provides Ack functionality too)
	Plug 'junegunn/fzf.vim'

	" buffer manager
	Plug 'jlanzarotta/bufexplorer', { 'on': ['BufExplorer'] }

	" better motions (f,t)
	Plug 'easymotion/vim-easymotion'

	" better slash searching
	Plug 'junegunn/vim-slash'

	" File explorer (netrw replacement)
	Plug 'scrooloose/nerdtree'

	" Similarly, load NERDTree git status plugin
	Plug 'Xuyuanp/nerdtree-git-plugin'

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

	" mapping-based alignment
	Plug 'junegunn/vim-easy-align'

	" emoji support
	Plug 'junegunn/vim-emoji', { 'on': ['Emojify'] }

	" highlight extra whitespaces
	Plug 'ntpeters/vim-better-whitespace'

	" add more text objects (https://github.com/kana/vim-textobj-user/wiki)
	Plug 'kana/vim-textobj-user'
	" text object: indents
	Plug 'kana/vim-textobj-indent'
	" text object: current line
	Plug 'kana/vim-textobj-line'
	" text object: comments
	Plug 'glts/vim-textobj-comment'

	" automatically detect indentation
	Plug 'tpope/vim-sleuth'

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
		autocmd Filetype tex,plaintex ++once echom 'Install latexmk texlive texlive-recommend texlive-latex-extra texlive-xetex for tex support!'
	endif

	" python auto formatting
	Plug 'tell-k/vim-autopep8', { 'for': 'python' }
	" Improved python highlighting
	Plug 'vim-python/python-syntax', { 'for': 'python' }

	" nginx configurations
	Plug 'chr4/nginx.vim', {'for': 'nginx'}

	" plugin for html/css editing (it handles its own filetypes)
	Plug 'mattn/emmet-vim'

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

	" load snippets on insert
	augroup load_snippets
		autocmd!
		autocmd InsertEnter * call plug#load('ultisnips', 'vim-snippets')
					\| autocmd! load_snippets
	augroup END

call plug#end()
