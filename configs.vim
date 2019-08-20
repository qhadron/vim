"rebinds semicolon to colon (easier to type)
nmap ; :

" Colorscheme
set background=dark
colorscheme peaksea
let g:colors_name="peaksea"

" change verticle split styling so it stands out from text
hi VertSplit ctermbg=fg ctermfg=bg

" Set relative line numbers with current line displayed instead of 0
set rnu
set number

" Folding Stuffs
set foldmethod=syntax
" Don't enable folding by default
set nofoldenable

" Set number of undos
set undolevels=10000

" Set indenting method
set cindent

" Spaces are not better than a tab character
set noexpandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set tabstop=4
set shiftwidth=4
set softtabstop=0

" Use English for spellchecking, but don't spellcheck by default (speed)
if version >= 700
   set spl=en spell 
   set nospell
endif

" Enable mouse support in console
set mouse=a

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>
nnoremap JJJJ <Nop>

" Get rid of Ex mode
nnoremap Q <nop>

" unnamed buffer
set clipboard+=unnamed

" quit all
nnoremap <leader>Q :qa<cr>

" Redraw
map <F5> :redraw!<cr>

" visual instead of audio bell
set visualbell

" set shell to zsh
set shell=zsh

" add command to open terminal
nnoremap <silent> <c-t> :tabnew +terminal++curwin<cr>

" 1 line high command line
set cmdheight=1

" auto commands for file types
augroup my_au_group
	" clear the group in case of reloading
	autocmd!

	" Enable spellcheck for markdown files
	autocmd Filetype markdown :setlocal spell

	" set indentation options for yaml files
	autocmd Filetype yaml :setlocal expandtab ts=2 sw=2

	" Set filetype for docker files
	autocmd BufNewFile,BufRead Dockerfile.* :setfiletype dockerfile

	" no numbering for terminal
	autocmd TerminalOpen set nonumber nornu

augroup END

" functions to profile vim
function! s:profile_start()
	profile start ~/vim_profile.log
	profile func *
	profile file *
endfunction

function! s:profile_end()
	profile pause
	tabnew ~/vim_profile.log
endfunction

" commands to use the functions
command ProfileStart call s:profile_start()
command ProfileEnd call s:profile_end()
