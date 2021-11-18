" vim: tabstop=4 shiftwidth=4 noexpandtab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=10000

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
try
	source $VIMRUNTIME/delmenu.vim
catch
endtry
try
	source $VIMRUNTIME/menu.vim
catch
endtry

" Enable command-line tab completion
set wildmenu
set wildmode=list:longest,full

" Allow buffers to be hidden
set hidden

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,[,]

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set visualbell

" Set scroll offset
set scrolloff=7

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set utf8 as standard encoding
set encoding=utf8

" Use Unix as the standard file type
set fileformats=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Turn on some autoindent settings
set autoindent
set smartindent
set wrap

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
augroup basic_au
	autocmd!
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set undodir=$VIM_PREFIX/temp_dirs/undodir
set undofile

" Save netrw file in temp dir
let g:netrw_home = $VIM_PREFIX . '/temp_dirs'

" Show the leader key as a command when pressed
set showcmd

" spell file
set spellfile=$VIM_PREFIX/spell/words.utf-8.add

" spell underline
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Use English for spellchecking, but don't spellcheck by default (speed)
if version >= 700
   set spl=en nospell
endif

" autoread file changes outside of vim
set autoread
" autoload changes (with prompt if modified) only for valid buffers
" (need to check getcmdwintype since &buftype could not be set for cmd window)
autocmd FocusGained,BufEnter * if &buftype=='' && getcmdwintype() == ''| checktime | endif

try
	" enable mouse stuff
	set mouse=a
	if has("mouse_sgr")
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	end
	" disable autoselect for mouse (speed improvement)
	set clipboard-=autoselect
catch
endtry


""""""""""""""""""""""""""""""
" => shell syntax folding
""""""""""""""""""""""""""""""
" shell (sh) syntax folding
let g:sh_fold_enabled=5 " &1 is functions, &2 is heredoc, &4 is ifdofor

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => add command to diff the edited buffer with filesystem version
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $VIM_PREFIX/extras/diff_orig.vim

""""""""""""""""""""""""""""""
" => Mode-dependent cursor
" use block in normal mode and line in insert mode
" https://github.com/mintty/mintty/wiki/Tips#mode-dependent-cursor-in-vim
""""""""""""""""""""""""""""""
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
