""""""""""""""""""""""""""""""
" => global stuff
""""""""""""""""""""""""""""""
let s:ag_command = 'ag --vimgrep --smart-case'

" function to get the sid
function! s:sid()
	return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>

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
let g:UltiSnipsExpandTrigger='<c-l>'
let g:UltiSnipsJumpBackwardTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-k>'


"""""""""""""""""""""""""""""""""""""""""""
" => vim-yoink, vim-subversive, vim-cutlass
"""""""""""""""""""""""""""""""""""""""""""
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

" don't update named registers (causes issue with first move)
let g:yoinkSyncNumberedRegisters = 0

" don't sync system clipboard because behaviour is strange
let g:yoinkSyncSystemClipboardOnFocus = 0

" subsitute (subversive) stuff
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" visual mode paste & swapping
xmap s <plug>(SubversiveSubstitute)
xmap p <plug>(SubversiveSubstitute)
xmap P <plug>(SubversiveSubstitute)

" cutlass makes default operations not yank
" use x as "move" binding
nnoremap m d
xnoremap m d

nnoremap mm dd
nnoremap M D

" yoink,cutlass compatibility
let g:yoinkIncludeDeleteOperations = 1

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
" set update time to make changes realtime
set updatetime=100


""""""""""""""""""""""""""""""
" => YouCompleteMe
""""""""""""""""""""""""""""""
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
" which filetypes to unblacklist for YCM
let g:ycm_filetype_unblacklist = ['markdown', 'text']

let s:ycm_identifiers_disabled=0
function! s:ycm_toggle_identifiers(force_disable)
	if !a:force_disable && !s:ycm_identifiers_disabled
		echom "Disabling YCM identifier completion..."
		let s:ycm_identifiers_disabled=1
		let s:old_ycm_min_num_of_chars_for_completion=g:ycm_min_num_of_chars_for_completion
		let g:ycm_min_num_of_chars_for_completion=99
	else
		echom "Restoring YCM identifier completion..."
		let s:ycm_identifiers_disabled=0
		try
			let g:ycm_min_num_of_chars_for_completion=s:old_ycm_min_num_of_chars_for_completion
		catch
		endtry
	endif
	try
		silent YcmRestartServer
	catch
	endtry
endfunction

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

		" disable blacklist for some files
		if exists('g:ycm_filetype_blacklist')
			for key in g:ycm_filetype_unblacklist
				if exists('g:ycm_filetype_blacklist.'.key)
					call remove(g:ycm_filetype_blacklist, key)
				endif
			endfor
		endif

		" use YCMToggleTextMode! to force disable text mode
		command -bang YCMToggleIdentifiers call s:ycm_toggle_identifiers(<bang>0)

		" add a mapping for that
		nnoremap <silent> <leader>yt :YCMToggleIdentifiers<cr>

	endif
endfunction

" YouCompleteMe mappings
augroup s:YCM_Mappings
	autocmd! User YouCompleteMe call s:addYcmMappings()
				\| autocmd! s:YCM_Mappings
augroup END

""""""""""""""""""""""""""""""
" => fzf
""""""""""""""""""""""""""""""
" change fzf default command to do better searching
let $FZF_DEFAULT_COMMAND = s:ag_command . ' -g ""'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" prefer to open in terminal mode in order to use terminal mode mappings
let g:fzf_prefer_term = 1

" set fzf layout (and open fzf in terminal window for the mappings)
let g:fzf_layout = {'down': '30%'}

function! s:configure_fzf_window()
	" decrease delay to close fzf windows after pressing <Esc>
	setlocal ttimeoutlen=10
endfunction

augroup s:custom_fzf_configs
	autocmd!
	autocmd Filetype fzf call s:configure_fzf_window()
augroup END

" search for regex (grep)
nnoremap <c-g> :Ag<space>

" Find files
nnoremap <silent> <leader>ff :Files<CR>

" Find all files (change the ag command to not ignore .gitignore etc)
function! s:find_all_files(...)
	let backup=$FZF_DEFAULT_COMMAND
	" search everything (-u) but ignore .git directory
	let $FZF_DEFAULT_COMMAND = s:ag_command . ' -g "" -u --ignore .git'
	call call('fzf#vim#files', a:000)
	let $FZF_DEFAULT_COMMAND = backup
endfunction
command! -bang -nargs=? -complete=dir AllFiles call s:find_all_files(<q-args>, <bang>0)
nnoremap <silent> <leader>fF :AllFiles<cr>

" source fzf cycle
source $VIM_PREFIX/extras/fzf_cycle.vim

" remember fzf mode or not when cycling
let g:fzf_cycle_remember_mode = 0

" override fzf cycle commands
let g:fzf_cycle_commands += [function('s:find_all_files')]

" bind fzf cycle
nnoremap <silent> <c-f> :FZFCycle<CR>

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

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
function! s:complete_word()
	if len(&dictionary)
		fzf#vim#complete('cat '.join(&dictionary))
	else
		echom "specify a value for 'dict' for word completion. (See :help 'dict')"
		return ''
	endif
endfunction

inoremap <expr> <c-x><c-k> <sid>complete_word()
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" use fzf to complete ultisnips snippets
let g:snippet_key_value_separator='   |   '
function! s:get_available_snippets(...)
	let snips = UltiSnips#SnippetsInCurrentScope(1)
	let lines=[]
	for key in keys(snips)
		let lines = add(lines, key . g:snippet_key_value_separator . snips[key])
	endfor
	return lines
endfunction

function! s:fzf_snippets_sink(lines)
	return split(a:lines[0], g:snippet_key_value_separator)[0]
endfunction

inoremap <expr> <c-x>s fzf#vim#complete(
			\ {
			\  'source': function('<sid>get_available_snippets'),
			\  'reducer': function('<sid>fzf_snippets_sink'),
			\  'options': '--delimiter "'.g:snippet_key_value_separator.'" --nth 1',
			\ }
			\ )

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
let g:vim_markdown_folding_disabled = 1
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
""""""""""""""""""""""""""""""
" open nerdtree if input is a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | call feedkeys("A") | exe 'cd '.argv()[0] | endif
" mapping to toggle nerdtree
nnoremap <silent> <c-m-l> :NERDTreeToggle<cr>

" natrual sort
let NERDTreeNaturalSort = 1
" close after opening file or bookmark
let NERDTreeQuitOnOpen = 3


""""""""""""""""""""""""""""""
" => vim-peekaboo
""""""""""""""""""""""""""""""
let g:peekaboo_window_percentage=40
function! s:open_peekaboo_window()
	execute 'vertical botright '.string(round(winwidth(0)/100.0*g:peekaboo_window_percentage))."new"
endfunction
let g:peekaboo_window='call '.s:sid().'open_peekaboo_window()'
let g:peekaboo_compact=0
let g:peekaboo_prefix='<leader>'


""""""""""""""""""""""""""""""
" => rainbow
""""""""""""""""""""""""""""""
" provide rainbow brackets by default
let g:rainbow_active = 1

""""""""""""""""""""""""""""""
" => vim-emoji
""""""""""""""""""""""""""""""
" enable emoji completion for :emote: syntax
set completefunc=emoji#complete
" replace :emote: with emojis for current line
" use Emojify! for whole file
" unrecognized emojis are not changed
command! -range -bang Emojify
			\ if <bang>0 |
			\   silent! %s/\m:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g |
			\ else |
			\   silent! <line1>,<line2>s/\m:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g |
			\ endif
nnoremap <silent> <leader>E :Emojify<cr>

""""""""""""""""""""""""""""""
" => vim-better-whitespace
""""""""""""""""""""""""""""""
" set the color for whitespace
let g:better_whitespace_ctermcolor='darkgrey'
" enable highlighting by default
let g:better_whitespace_enabled=1

" change strip mapping
let g:better_whitespace_operator='<leader>S'
" strip changed lines file
nnoremap <silent> <leader>W :StripWhitespace<cr>
" navigate between bad whitespace
nnoremap ]w :NextTrailingWhitespace<CR>
nnoremap [w :PrevTrailingWhitespace<CR>

" enable autostrip on save
let g:strip_whitespace_on_save=1
" for modified lines only
let g:strip_only_modified_lines=1
" but don't confirm (since it's only modified lines)
let g:strip_whitespace_confirm=0

" strip whitespace at eof?
let g:strip_whitelines_at_eof=1

" disable whitespace checking for term normal mode
augroup disable_whitespace
	autocmd!
	autocmd TerminalOpen * DisableWhitespace
augroup END

""""""""""""""""""""""""""""""
" => tcomment
""""""""""""""""""""""""""""""
" disable leader key mappings
let g:tcomment_mapleader2=''


""""""""""""""""""""""""""""""
" => vimtex
""""""""""""""""""""""""""""""
" set the vim latex flavour (avoid detecting .tex as plaintex ft)
let g:tex_flavor = 'latex'

" close quickfix after keystrokes
let g:vimtex_quickfix_autoclose_after_keystrokes=1

" set the compiler to latexmk
let g:vimtex_compiler_method = 'latexmk'

let g:vimtex_compiler_build_dir = '.tex.build'

let g:vimtex_compiler_latexmk = {
	\ 'build_dir': g:vimtex_compiler_build_dir,
	\ 'options' : [
	\   '-pdf',
	\   '-verbose',
	\   '-file-line-error',
	\   '-synctex=1',
	\   '-interaction=nonstopmode',
	\ ],
	\}

augroup vimtex_customization
	autocmd!
	autocmd User VimtexEventInitPost call s:on_vimtex_load()
	autocmd User VimtexCompileStarted call s:vimtex_build_folder()
augroup END

function s:on_vimtex_load()
	" add fzf integration
	nnoremap <localleader>lf :call vimtex#fzf#run()<cr>
	" make vimtex build folder
	call s:vimtex_build_folder()
endfunction

function s:vimtex_build_folder()
	let old_path=getcwd()
	execute 'cd '.expand('%:h:p')
	" if build folder is not a directory delete it
	if !isdirectory(g:vimtex_compiler_build_dir)
		call delete(g:vimtex_compiler_build_dir)
	endif
	" make the build folder if it doesn't exist
	if empty(glob(g:vimtex_compiler_build_dir))
		call mkdir(g:vimtex_compiler_build_dir,"p")
		" hide the folder if on windows-like systems
		if executable('attrib.exe')
			silent call system(join(['attrib.exe', '+h', '/s', '/d', g:vimtex_compiler_build_dir],' '))
		endif
	endif
	execute 'cd '.old_path
endfunction
