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
nnoremap x d
xnoremap x d

nnoremap xx dd
nnoremap X D

" yoink,cutlass compatibility
let g:yoinkIncludeDeleteOperations = 1

""""""""""""""""""""""""""""""
" => lightline
""""""""""""""""""""""""""""""
set noshowmode

" show lightline itsel0
set laststatus=2

" padding for tab heading
let s:lightline_tab_min_padding=20
" extra size for the active tab size
let s:lightline_tab_active_page_extra=0

let g:lightline = {
	\ 'colorscheme': 'powerline',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'coc-status', 'readonly', 'filename', 'fugitive' ] ],
	\   'right': [ [ 'lineinfo' ],
	\              [ 'percent' ],
	\              [ 'sleuth', 'fileformat', 'fileencoding', 'filetype'],
    \              [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ] ]
	\ },
	\ 'inactive': {
	\   'left': [ [ 'readonly', 'filename', 'fugitive' ] ],
	\   'right': [ [ 'lineinfo' ],
	\              [ 'percent' ],
	\              [ 'fileencoding', 'filetype' ] ]
	\ },
	\ 'tab': {
	\   'active': [  'tabnum', 'tab_filenames', 'modified'  ],
	\   'inactive': [  'tabnum', 'tab_filenames', 'modified' ],
	\ },
	\ 'tab_component_function': {
	\   'tab_filenames': 'TabFilenames',
	\ },
	\ 'component': {
	\   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
	\   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
	\   'sleuth': '%{SleuthIndicator()}'
	\ },
	\ 'component_visible_condition': {
	\   'readonly': '(&filetype!="help"&& &readonly)',
	\   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
	\ },
	\ 'component_function': {
	\   'filename': 'LightlineFilename',
	\   'cocstatus': 'coc#status'
	\ },
	\ 'component_expand': {
	\ },
	\ 'component_type': {
	\ },
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '|', 'right': '|' }
	\ }

" lightline-ale configuration
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

" lightline-ale configuration
let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }

" show filename
function! LightlineFilename()
	let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	let modified = &modified ? ' +' : ''
	return filename . modified
endfunction

function! s:expensive_unique(list)
	let seen = {}
	let output=[]
	for item in a:list
		if ! has_key(seen, item)
			call add(output, item)
			let seen[item]=1
		endif
	endfor
	return output
endfunction

function! TabFilenames(tabnr)
	let buffers=s:expensive_unique(tabpagebuflist(a:tabnr))
	let active_buffer=winbufnr(win_getid(tabpagewinnr(a:tabnr), a:tabnr))

	" move active buffer to first
	call remove(buffers, index(buffers, active_buffer))
	call insert(buffers, active_buffer)

	" generate names
	let names=[]
	for buffer in buffers[ : 2] " get first 3 names
		let type=getbufvar(buffer, '&buftype', 'nofile')
		if type == ''
			let name = bufname(buffer)
			if name == ''
				let name = '[No Name]'
			else
				let name = simplify(name)
			endif
		else
			let name='['.type.']'
		endif
		call add(names, name)
	endfor

	" trim to a shorter length
	let result=join(names, ',')
	let tab_size = float2nr(round(
		\ ( &columns - s:lightline_tab_min_padding +
		\   ((tabpagenr() == a:tabnr ? 1.0 : -1.0) * s:lightline_tab_active_page_extra))
		\ / tabpagenr('$')
		\ ))-3 " -3 for the dots
	if len(result)>tab_size
		let display_len=max([tab_size, len(names[0])])
		let result = result[:display_len].'...'
	endif
	return result
endfunction

""""""""""""""""""""""""""""""
" => git gutter
""""""""""""""""""""""""""""""
" disable by default
let g:gitgutter_enabled=0
" add binding to toggle for the buffer
nnoremap <silent> <leader>gg :GitGutterToggle<cr>
" add binding to stage a hunk
nmap <silent> <leader>ga <Plug>(GitGutterStageHunk)
" add binding to undo a hunk
nmap <silent> <leader>gu <Plug>(GitGutterUndoHunk)
" add binding to preview a hunk
nmap <silent> <leader>gp <Plug>(GitGutterPreviewHunk)
" enable highlighting by default
let g:gitgutter_highlight_lines = 1
" use ag instead of grep
if executable('ag')
	let g:gitgutter_grep = 'ag'
endif
" set update time to make changes realtime
set updatetime=100

""""""""""""""""""""""""""""""
" => coc
""""""""""""""""""""""""""""""
let g:coc_global_extensions = ['coc-marketplace']

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <F2> <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>F  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" Marketplace
nnoremap <silent><nowait> <space>m  :<C-u>CocListmar<CR>

""""""""""""""""""""""""""""""
" => fzf
""""""""""""""""""""""""""""""
" change fzf default command to do better searching
let $FZF_DEFAULT_COMMAND = s:ag_command . ' -g ""'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

" set fzf layout (and open fzf in terminal window for the mappings)
let g:fzf_layout = {'window': 'bot'.float2nr(&lines * 0.3).'new' }

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
" Find tags
nnoremap <silent> <leader>ft :Filetypes<CR>
" Find filetypes
nnoremap <silent> <leader>fT :Filetypes<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
function! s:complete_word()
	if len(&dictionary)
		return fzf#vim#complete('cat '.&dictionary)
	else
		echom "Specify a value for 'dict' for word completion. (See :help 'dict'). Try installing 'wordlist' package."
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
let g:vim_markdown_folding_disabled = 0
augroup s:vim_markdown
	autocmd!
	" add message: disable folding for better performance
	autocmd User vim-markdown echom 'disable markdown folding for better performance (help vim-markdown-disable-folding)'
augroup end


" don't add indent levels on new list items
let g:vim_markdown_new_list_item_indent = 0
" don't auto insert bulletpoints
let g:vim_markdown_auto_insert_bullets = 0
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

" disable bindings
map <Plug> <Plug>Markdown_MoveToCurHeader
""""""""""""""""""""""""""""""
" => Nerd tree
""""""""""""""""""""""""""""""
" open nerdtree if input is a directory
augroup s:nerd_tree
	autocmd!
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | call feedkeys("A") | exe 'cd '.argv()[0] | endif
augroup end

" mapping to toggle nerdtree
nnoremap <silent> <c-m-l> :NERDTreeToggle<cr>

" natrual sort
let g:NERDTreeNaturalSort = 1
" close after opening file or bookmark
let g:NERDTreeQuitOnOpen = 3


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

augroup s:vim_better_whitespace
	autocmd!
	" disable whitespace checking for term normal mode
	autocmd TerminalOpen * DisableWhitespace
	" disable whitespace checking for markdown
	" (some variantes use 2 spaces for line break)
	autocmd FileType markdown DisableWhitespace
	" disable whitespace checking for snippets
	" (sometimes it's useful to have spaces at the end)
	autocmd FileType snippets DisableWhitespace
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

augroup s:vimtex
	autocmd!
	autocmd User VimtexEventInitPost call s:on_vimtex_load()
	autocmd User VimtexCompileStarted call s:vimtex_build_folder()
augroup END

function! s:on_vimtex_load()
	" add fzf integration
	nnoremap <localleader>lf :call vimtex#fzf#run()<cr>
	" make vimtex build folder
	call s:vimtex_build_folder()
endfunction

function! s:vimtex_build_folder()
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

""""""""""""""""""""""""""""""
" => vim-slash
""""""""""""""""""""""""""""""
" center on screen (zz) and flash search result
if has('timers')
	" Blink 2 times with 50ms interval
	noremap <expr> <plug>(slash-after) 'zz'.slash#blink(3, 50)
endif

""""""""""""""""""""""""""""""
" => vim-easy-align
""""""""""""""""""""""""""""""
" add mappings
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

""""""""""""""""""""""""""""""
" => vim-autopep8
""""""""""""""""""""""""""""""
let g:autopep8_max_line_length=79
let g:autopep8_indent_size=4
let g:autopep8_disable_show_diff=1


" check if autopep8 is available before loading it
function! s:check_load_pep8()
	" actually make sure autopep8 is real!
	" pyenv creates fake shims that are executable but fails
	if executable('autopep8') && !empty(system('autopep8 --version')) && v:shell_error==0
		let g:autopep8_on_save = 1
	else
		echohl WarningMsg
		echo 'autopep8 is not executable...'
		echohl None
		let g:autopep8_on_save = 0
	endif
endfunction

augroup s:autopep8
	autocmd!
	autocmd FileType python call s:check_load_pep8()
augroup end


""""""""""""""""""""""""""""""
" => python-syntax
""""""""""""""""""""""""""""""
let g:python_version_2 = 0
let g:python_highlight_all = 1

""""""""""""""""""""""""""""""
" => emmet-vim
""""""""""""""""""""""""""""""
" enable in all modes
let g:user_emmet_mode = 'a'
" activate emmet features
let g:user_emmet_leader_key='<c-e>'
" enable for additional languages
let g:user_emmet_settings = {
	\  'xml' : {
	\    'extends' : 'html',
	\  },
	\  'markdown' : {
	\    'extends' : 'html',
	\  },
	\}

""""""""""""""""""""""""""""""
" => markdown-preview.nvim
""""""""""""""""""""""""""""""
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_command_for_global = 1

" refresh on save or leave insert mode
" (sometimes it takes a long time to render after many updates)
let g:mkdp_refresh_slow = 1

" output only html for speed (no MathML for accessibility)
let g:mkdp_preview_options = {
			\ 'katex' : { 'output': 'html' },
			\ }

function! s:mkdp_restart()
	if !exists('*mkdp#util#toggle_preview')
		return
	endif
	call mkdp#util#stop_preview()
	call mkdp#util#open_preview_page()
endfunction

command! MKDPRestart call s:mkdp_restart()


""""""""""""""""""""""""""""""
" => md-img-paste
""""""""""""""""""""""""""""""
let g:mdip_imgdir = 'img'
let g:mdip_imgname = 'pasted_image'

augroup s:markdown_image_paste
	autocmd!
	autocmd FileType markdown nnoremap <buffer><silent> <leader>pi :call mdip#MarkdownClipboardImage()<CR>
	autocmd User md-img-paste if ! executable('xclip') | echoe "Install xclip to paste images" | endif
augroup END
