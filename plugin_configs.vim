" vim: tabstop=4 shiftwidth=4 noexpandtab
""""""""""""""""""""""""""""""
" => global stuff
""""""""""""""""""""""""""""""
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
let g:UltiSnipsExpandTrigger='<a-l>'
let g:UltiSnipsJumpBackwardTrigger='<a-j>'
let g:UltiSnipsJumpForwardTrigger='<a-k>'


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
			\             [ 'readonly', 'filename', 'fugitive' ],
			\             [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status' ]],
			\   'right': [ [ 'lineinfo' ],
			\              [ 'percent' ],
			\              [ 'sleuth', 'fileformat', 'fileencoding', 'filetype'] ]
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

" change symbols
let g:lightline#coc#indicator_warnings='⚠️ '
let g:lightline#coc#indicator_errors='ⓧ '
let g:lightline#coc#indicator_info='ⓘ '
let g:lightline#coc#indicator_hints='❔'
let g:lightline#coc#indicator_ok='✔️ '

" register coc components
call lightline#coc#register()

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
		elseif type == 'terminal'
			let name='['.term_gettitle(buffer).']'
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
		let display_len=min([tab_size, len(names[0])])
		let result = result[:display_len].'...'
	endif
	return result
endfunction

""""""""""""""""""""""""""""""
" => coc.nvim
""""""""""""""""""""""""""""""
" set update time to make changes realtime
set updatetime=100

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" enable semantic highlighting
let g:coc_default_semantic_highlight_groups = 1

autocmd User CocNvimInit call s:on_coc_load()
" this is needed so that coc settings overwrite any other plugin's settings
function! s:on_coc_load()
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

	" Use `[d` and `]d` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [d <Plug>(coc-diagnostic-prev)
	nmap <silent> ]d <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy :<C-u>CocCommand fzf-preview.CocTypeDefinitions<cr>
	nmap <silent> gi :<C-u>CocCommand fzf-preview.CocImplementations
	nmap <silent> gr :<C-u>CocCommand fzf-preview.CocReferences<cr>


	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>
	xnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('definitionHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <F2> <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)
	" Formatting entire document
	nmap <leader>F  <Plug>(coc-format)

	augroup coc_autos
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

	" Remap <C-d> and <C-u> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
		nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
		inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-d>"
		inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-u>"
		vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
		vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
	endif


	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>d  :<C-u>CocCommand fzf-preview.CocDiagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Open sources
	nnoremap <silent><nowait> <space>s  :<C-u>CocList sources<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
	" Marketplace
	nnoremap <silent><nowait> <space>m  :<C-u>CocList marketplace<CR>
	" Coc lists
	nnoremap <silent><nowait> <space>l  :<C-u>CocList lists<CR>
endfunction

""""""""""""""""""""""""""""""
" => fzf
""""""""""""""""""""""""""""""
" change fzf default command to do better searching
if executable('rg')
	let $FZF_DEFAULT_COMMAND = 'rg --files .'
elseif executable('ag')
	let $FZF_DEFAULT_COMMAND = 'ag --vimgrep -g ""'
endif
""""""""""""""""""""""""""""""

" => goyo
""""""""""""""""""""""""""""""

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 0

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
imap <c-x><c-j> <plug>(fzf-complete-file)
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
" => fzf-preview.vim
""""""""""""""""""""""""""""""
" fzf mappings

nnoremap <silent> <c-f> <nop>
nnoremap <silent> <c-f><c-f>       :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> <c-f><space>     :<C-u>CocCommand fzf-preview.DirectoryFiles<CR>
nnoremap <silent> <c-f>f           :<C-u>CocCommand fzf-preview.FromResources<CR>
nnoremap <silent> <c-f>F           :<C-u>CocCommand fzf-preview.Lines<CR>
nnoremap <silent> <c-f>gs          :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> <c-f>ga          :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> <c-f>b           :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> <c-f><C-o>       :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> <c-f>d           :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> <c-f>/           :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> <c-f>*           :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <c-f>l           :<C-u>CocCommand fzf-preview.BufferLines<CR>
nnoremap <silent> <c-f>L           :<C-u>CocCommand fzf-preview.LocationList<CR>

nnoremap          <c-g>            :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          <c-g>            "sy:CocCommand fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
" replace the old <c-g> functionality
" -> show filename
nnoremap          <f1>             <c-g>
" -> enter select mode
xnoremap          <c-s>            <c-g>

" fzf command default options
let g:fzf_preview_default_fzf_options = { '--reverse': v:true, '--preview-window': ':wrap:hidden' }

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
nnoremap <silent> <m-l> :NERDTreeToggle<cr>

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
" disable operator maps (conflicts with coc-git)
let g:tcomment_opleader1=''


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
	autocmd User VimtexEventCompileStarted call s:vimtex_build_folder()
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
		" hide the folder from dropbox
		if executable('powershell.exe')
			silent call system(join(['powershell.exe','-sta', 'Set-Content -Path '.g:vimtex_compiler_build_dir.' -Stream com.dropbox.ignored -Value 1']))
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

""""""""""""""""""""""""""""""
" => vim-workspace
""""""""""""""""""""""""""""""
let g:workspace_session_directory = $VIM_PREFIX."/temp_dirs/sessions/"
let g:workspace_session_disable_on_args = 1
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0

""""""""""""""""""""""""""""""
" => FastFold
""""""""""""""""""""""""""""""
" shortcut for updating folds
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C', 'm', 'M', 'r', 'R']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']


""""""""""""""""""""""""""""""
" => SimpylFold
""""""""""""""""""""""""""""""
" preview docstring in fold text
let g:SimpylFold_docstring_preview = 1

""""""""""""""""""""""""""""""
" => vim-polyglot
""""""""""""""""""""""""""""""
" add disabled filetypes here
" add <ft>.plugin to disable filetype highlighting without disabling detection
let g:polyglot_disabled = ['sensible']
autocmd VimEnter * ++once call plug#load('vim-polyglot')

""""""""""""""""""""""""""""""
" => coc-git
""""""""""""""""""""""""""""""
" navigate chunks of current buffer
nmap <silent> [g <Plug>(coc-git-prevchunk)
nmap <silent> ]g <Plug>(coc-git-nextchunk)
" navigate git conflicts of current buffer
nmap <silent> [gc <Plug>(coc-git-prevconflict)
nmap <silent> ]gc <Plug>(coc-git-nextconflict)

" create text object for git chunks
omap <silent> ig <Plug>(coc-git-chunk-inner)
xmap <silent> ig <Plug>(coc-git-chunk-inner)
omap <silent> ag <Plug>(coc-git-chunk-outer)
xmap <silent> ag <Plug>(coc-git-chunk-outer)

" toggle gutters
nmap <silent> ,gg :<c-u>CocCommand git.toggleGutters<cr>
" undo chunk
nmap <silent> ,gu :<c-u>CocCommand git.chunkUndo<cr>
" stage chunk
nmap <silent> ,ga :<c-u>CocCommand git.chunkStage<cr>
" show chunk diff at current position
nmap <silent> ,gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap <silent> ,gc <Plug>(coc-git-commit)
" copy current line URL
nmap <silent> ,gy :<c-u>CocCommand git.copyUrl<cr>
" show cached diff
nmap <silent> ,gC :<c-u>CocCommand git.diffCached<cr>

""""""""""""""""""""""""""""""""
" => vim-html-template-literals
""""""""""""""""""""""""""""""""
let g:htl_css_templates=1
