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

	" expand single line of code / contract multiple lines of code
	Plug 'andrewradev/splitjoin.vim'

	" wrapper for unix commands for vim (mv, rm, mkdir, etc)
	Plug 'tpope/vim-eunuch'

	""""""""""""""""""""""""""""""
	" => syntax/filetype support
	""""""""""""""""""""""""""""""

	" syntax checking
	Plug 'dense-analysis/ale'
	" lightline plugin for ale
	Plug 'maximbaz/lightline-ale'

	" markdown support
	Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
	" markdown preview
	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
	" paste images for markdown
	Plug 'ferrine/md-img-paste.vim', { 'as': 'md-img-paste', 'for': 'markdown' }

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

	" better javascript highlighting
	Plug 'yuezk/vim-js'

	" typescript support
	Plug 'HerringtonDarkholme/yats.vim'

	" jsx/tsx highlighting and extras
	Plug 'maxmellon/vim-jsx-pretty'

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

	" completion plugin: conquer of completion
	Plug 'neoclide/coc.nvim', {'branch': 'release', 'on': []}
    " loading on insert is necessary since some mappings (i.e. gd) gets
    " overwritten by other plugins (i.e. vim-slash)
	augroup load_coc
		autocmd!
		autocmd InsertEnter * ++once call plug#load('coc.nvim')
	augroup END

	" comment/uncomment with proper escaping
	Plug 'tomtom/tcomment_vim', { 'as': 'tcomment' }

	if has('python3')
		" snippet manager
		Plug 'SirVer/ultisnips', { 'on': [] }
		" snippets for the manager
		Plug 'honza/vim-snippets', { 'on': [] }
		" load snippets on insert
		augroup load_snippets
			autocmd!
			autocmd InsertEnter * ++once call plug#load('ultisnips', 'vim-snippets')
		augroup END
	else
		echo "Need vim with +python3 to enable snippet support"
	endif


call plug#end()
