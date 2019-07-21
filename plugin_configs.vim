""""""""""""""""""""""""""""""
" => global stuff
""""""""""""""""""""""""""""""
let s:ag_command = 'ag --vimgrep --smart-case'
""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=1
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=0
let g:bufExplorerSortBy='mru'
let g:bufExplorerSplitBelow=0
let g:bufExplorerSplitRight=1
" replace default mapping
nnoremap <silent> <leader>o :BufExplorer<cr>
silent! nunmap <leader>bt

""""""""""""""""""""""""""""""
" => Easy Motion
""""""""""""""""""""""""""""""
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1


""""""""""""""""""""""""""""""
" => UltiSnips
""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"


""""""""""""""""""""""""""""""
" => vim-yoink, vim-subversive
""""""""""""""""""""""""""""""
" yoink stuff

" swap after pasting
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)

" remap p to save history
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" preserve history when yanking
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)

" yank history
let g:yoinkMaxItems = 20

" also update named registers
let g:yoinkSyncNumberedRegisters = 1

" subsitute (subversive) stuff
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

""""""""""""""""""""""""""""""
" => lightline
""""""""""""""""""""""""""""""
set noshowmode

" show lightline itself
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'gitbranch' ] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

" show filename
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

""""""""""""""""""""""""""""""
" => syntastic
""""""""""""""""""""""""""""""

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


""""""""""""""""""""""""""""""
" => git gutter
""""""""""""""""""""""""""""""
" disable by default
let g:gitgutter_enabled=0
" add binding to toggle for the buffer
nnoremap <silent> <leader>g :GitGutterToggle<cr>
" enable highlighting by default
let g:gitgutter_highlight_lines = 1
" use ag instead of grep
if executable('ag')
	let g:gitgutter_grep = 'ag'
endif


""""""""""""""""""""""""""""""
" => YouCompleteMe
""""""""""""""""""""""""""""""
" command to enable YCM (triggers vim-plug)
command! YCM call plug#load('YouCompleteMe')

" YouCompleteMe configs
if len(glob('~/.ycm.py'))
	let g:ycm_global_ycm_extra_conf  = '~/.ycm.py'
endif
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_max_num_candidates = 50
let g:ycm_warning_symbol = '##'
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_auto_trigger = 1

let s:ycm_keybinds_added = 0
function! s:addYcmMappings() 
	if ! s:ycm_keybinds_added
		nnoremap <c-c>D :YcmDiags<CR>
		nnoremap <c-F5> :YcmForceCompileAndDiagnostics<CR>
		nnoremap <c-c><F5> :YcmRestartServer<CR>
		nnoremap <c-c>g :YcmCompleter GoTo<CR>
		nnoremap <c-c>gd :YcmCompleter GoToDeclaration<CR>
		nnoremap <c-c>t :YcmCompleter GetType<CR>
		nnoremap <c-c>d :YcmCompleter GetDoc<CR>
		nnoremap <c-c>f :YcmCompleter FixIt<CR>
		nnoremap <c-c><c-f> :YcmCompleter Format<CR>
		nnoremap <c-c>o :YcmCompleter OrganizeImports<CR>
		nnoremap <F2> :YcmCompleter RefactorRename 
		let g:ycm_key_detailed_diagnostics = '<c-c><c-d>'
		let g:ycm_key_invoke_completion = '<C-Space>'
		if v:vim_did_enter
			echom 'YouCompleteMe loaded!'
		endif
		let s:ycm_keybinds_added = 1
	endif
endfunction	

" YouCompleteMe mappings
augroup s:YCM_Mappings
	autocmd! User YouCompleteMe call s:addYcmMappings()
				\| autocmd! s:YCM_Mappings
augroup END

""""""""""""""""""""""""""""""
" => ctrlp
""""""""""""""""""""""""""""""
" Only using ctrlp for mru, so remove the key bindings
let g:ctrlp_map = ''
let g:ctrlp_cmd = ''

""""""""""""""""""""""""""""""
" => fzf
""""""""""""""""""""""""""""""
" change fzf default command to do better searching
let $FZF_DEFAULT_COMMAND = s:ag_command . ' -g ""'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" helpers to find files
" {{{ The following code taken from https://github.com/junegunn/fzf.vim/blob/359a80e3a34aacbd5257713b6a88aa085337166f/autoload/fzf/vim.vim

function! s:sort_buffers(...)
  let [b1, b2] = map(copy(a:000), 'get(g:fzf#vim#buffers, v:val, v:val)')
  " Using minus between a float and a number in a sort function causes an error
  return b1 < b2 ? 1 : -1
endfunction

function! s:buflisted_sorted()
  return sort(filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"'), 's:sort_buffers')
endfunction

function! s:buffer_list()
  return map(
    \ filter([expand('%')], 'len(v:val)')
    \   + filter(map(s:buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)'),
    \ 'fnamemodify(v:val, ":~:.")')
endfunction

function! s:old_files()
  return map(
    \ filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
    \ 'fnamemodify(v:val, ":~:.")')
endfunction

" }}}

" if ctrl+f should be in fullscreen or not
let g:c_f_fullscreen=1

" Source option explanation
" [line 1] use bash for input redirection & process substitution
" [line 1] use awk to remove repeated entries [https://stackoverflow.com/a/11532197]
" [line 2] current file + buffer list
" [line 3] files in current directory
" [line 4] old files
command! FZFMixed call fzf#run(fzf#wrap('find-all', fzf#vim#with_preview({
			\ 'source': 'bash -c '' awk \!x\[\$0]\+\+ '.
			\ '<(tr "\r" "\n" <<<"'.join(s:buffer_list(), "\r").'") '.
			\ '<('.$FZF_DEFAULT_COMMAND.') '.
			\ '<(tr "\r" "\n" <<<"'. join(ctrlp#mrufiles#list(), "\r") .'") '.
			\ '''',
			\ 'down': '50%',
			\ 'options': '--no-sort --multi --prompt "Choice> " --header-lines 1',
			\}), g:c_f_fullscreen))
" the 1 above means fullscreen

" search for regex (grep)
nnoremap <c-g> :Ag<space>

" c-f to find files
nnoremap <silent> <c-f> :FZFMixed<CR>

" Find mappings
nmap <silent> <leader>fm <plug>(fzf-maps-n)
" Find files
nnoremap <silent> <leader>ff :Files<CR>
" Find git files
nnoremap <silent> <leader>fF :GFiles<CR>
" Find buffers
nnoremap <silent> <leader>fb :Buffers<CR>
" Find history (open bufferes and most recently used (v:oldfiles))
nnoremap <silent> <leader>fh :History<CR>
" Find commits
nnoremap <silent> <leader>fg :Commits<CR>
" Find commands
nnoremap <silent> <leader>fc :Commands<CR>
" Find (current buffer) lines
nnoremap <silent> <leader>fl :BLines<CR>
" Find global lines
nnoremap <silent> <leader>fL :Lines<CR>
" Find filetypes
nnoremap <silent> <leader>ft :Filetypes<CR>

""""""""""""""""""""""""""""""
" => goyo
""""""""""""""""""""""""""""""
nmap <leader>z :Goyo<CR>
let g:goyo_width = '80'
let g:goyo_height = '95%'
" hide line numbers
let g:goyo_linenr = 0 

""""""""""""""""""""""""""""""
" => vim-markdown
""""""""""""""""""""""""""""""
" disable folding for better performance
let g:vim_markdown_folding_dlisabled = 1
" don't add indent levels on new list items
let g:vim_markdown_new_list_item_indent = 0
" enable strikethrough
let g:vim_markdown_strikethrough = 1
" enable json
let g:vim_markdown_json_frontmatter = 1
" enable yaml
let g:vim_markdown_frontmatter = 1
" enable math
let g:vim_markdown_math = 1
" enable TOC table to be shrinked
let g:vim_markdown_toc_autofit = 1

""""""""""""""""""""""""""""""
" => Nerd tree
""""""""""""""""""""""""""""""-
" open nerdtree if input is a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | call feedkeys("A") | exe 'cd '.argv()[0] | endif
" mapping to toggle nerdtree
nnoremap <c-m-l> :NERDTreeToggle<cr>

" natrual sort
let NERDTreeNaturalSort = 1
" close after opening file or bookmark
let NERDTreeQuitOnOpen = 3
