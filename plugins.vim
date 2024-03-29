" vim: tabstop=4 shiftwidth=4 noexpandtab
" start plugin list
call plug#begin($VIM_PREFIX . '/plugged')
""""""""""""""""""""""""""""""
" => Vim Plug (add help docs)
""""""""""""""""""""""""""""""
Plug 'junegunn/vim-plug'

""""""""""""""""""""""""""""""
" => Vim helpers
""""""""""""""""""""""""""""""
Plug 'skywind3000/asyncrun.vim'

""""""""""""""""""""""""""""""
" => Visual
""""""""""""""""""""""""""""""

" colours
" cool dark theme
Plug 'joshdick/onedark.vim'

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
" open fzf in preview windows
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

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

" tmux
Plug 'christoomey/vim-tmux-navigator'

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

" expand single line of code / contract multiple lines of code
Plug 'andrewradev/splitjoin.vim'

" wrapper for unix commands for vim (mv, rm, mkdir, etc)
Plug 'tpope/vim-eunuch'

" vim session management
Plug 'thaerkh/vim-workspace'

" faster folds by updating slower
Plug 'Konfekt/FastFold'

" Search unicode characters
Plug 'chrisbra/unicode.vim'

" automatically use editor config
Plug 'editorconfig/editorconfig-vim'

""""""""""""""""""""""""""""""
" => syntax/filetype support
""""""""""""""""""""""""""""""
" most filetypes
Plug 'sheerun/vim-polyglot', { 'on': [] } " load after config

" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" paste images for markdown
Plug 'ferrine/md-img-paste.vim', { 'as': 'md-img-paste', 'for': 'markdown' }

" javscript template literals
" requires vim-javascript, provided by vim-polyglot
Plug 'jonsmithers/vim-html-template-literals'

" LaTeX support
if executable('latexmk')
	Plug 'lervag/vimtex'
else
	autocmd Filetype tex,plaintex ++once echom 'Install latexmk texlive texlive-recommend texlive-latex-extra texlive-xetex for tex support!'
endif

" python auto formatting
Plug 'tell-k/vim-autopep8', { 'for': 'python' }
" python folding
Plug 'tmhedberg/SimpylFold'

" plugin for html/css editing (it handles its own filetypes)
Plug 'mattn/emmet-vim'

" highlight css colors
Plug 'ap/vim-css-color'

" edit GPG encrypted files
Plug 'jamessan/vim-gnupg'

" better vimscript indenting
Plug 'rbtnn/vim-vimscript_indentexpr'
" semantic hilighting
""""""""""""""""""""""""""""""
" => Git
""""""""""""""""""""""""""""""

" git
Plug 'tpope/vim-fugitive'

""""""""""""""""""""""""""""""
" => Programming
""""""""""""""""""""""""""""""

" completion plugin: conquer of completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" lightline plugin
Plug 'josa42/vim-lightline-coc'

" coc extensions
let g:coc_global_extensions = []
" easily install extension
let g:coc_global_extensions += ['coc-marketplace']
" snippets
let g:coc_global_extensions += ['coc-ultisnips']
" json support & coc-settings.json autocomplete
let g:coc_global_extensions += ['coc-json']
" vimscript support
let g:coc_global_extensions += ['coc-vimlsp']
" diagnostic server: linting & formatting support
let g:coc_global_extensions += ['coc-diagnostic']
" pyright
let g:coc_global_extensions += ['coc-pyright']
" javascript/typescript
let g:coc_global_extensions += ['coc-eslint', 'coc-tsserver']
" css
let g:coc_global_extensions += ['coc-css']
" react
let g:coc_global_extensions += ['coc-react-refactor', 'coc-cssmodules']

" calculator for numerical expressions
let g:coc_global_extensions += ['coc-calc']
" fzf preview also installed here for coc specific stuff
" most of the time the regular plugin is used
let g:coc_global_extensions += ['coc-fzf-preview']

" c/c++ and semantic highlighting
let g:coc_global_extensions += ['coc-clangd']
Plug 'jackguo380/vim-lsp-cxx-highlight'

" git stuff
let g:coc_global_extensions += ['coc-git']

" formatting
let g:coc_global_extensions += ['coc-prettier']

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
