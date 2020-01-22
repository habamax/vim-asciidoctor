" Vim filetype plugin
" Language:   asciidoctor
" Maintainer: Maxim Kim <habamax@gmail.com>
" Filenames:  *.adoc
" vim: noet

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= "|setl cms< com< fo< flp< inex< efm< cfu<"
else
	let b:undo_ftplugin = "setl cms< com< fo< flp< inex< efm< cfu<"
endif

compiler asciidoctor2html

" open files
if get(g:, 'asciidoctor_opener', '') == ''
	if has("win32") || has("win32unix")
		if has("nvim")
			let g:asciidoctor_opener = ':silent !start ""'
		else
			let g:asciidoctor_opener = ':silent !start'
		endif
	elseif has("osx")
		let g:asciidoctor_opener = ":!open"
	else
		let g:asciidoctor_opener = ":!xdg-open"
	endif
endif

" see https://github.com/asciidoctor/asciidoctor-pdf/issues/1273
setlocal errorformat=asciidoctor:\ ERROR:\ %f:\ line\ %l:\ %m

" gf to open include files
setlocal includeexpr=substitute(v:fname,'include::\\(.\\{-}\\)\\[.*','\\1','g')
setlocal comments=
setlocal commentstring=//\ %s
" vim-commentary plugin setup
let b:commentary_startofline = 1

setlocal formatoptions+=cqn
setlocal formatlistpat=^\\s*
setlocal formatlistpat+=[
setlocal formatlistpat+=\\[({]\\?
setlocal formatlistpat+=\\(
setlocal formatlistpat+=[0-9]\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=[a-zA-Z]
setlocal formatlistpat+=\\)
setlocal formatlistpat+=[\\]:.)}
setlocal formatlistpat+=]
setlocal formatlistpat+=\\s\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=^\\s*-\\s\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=^\\s*[*]\\+\\s\\+

function! AsciidoctorFold() "{{{
	let line = getline(v:lnum)

	" Regular headers
	let depth = match(line, '\(^=\+\)\@<=\( .*$\)\@=')

	" Setext style headings
	if depth < 0
		let prevline = getline(v:lnum - 1)
		let nextline = getline(v:lnum + 1)

		if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
			let depth = 2
		endif

		if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
			let depth = 3
		endif

		if (line =~ '^.\+$') && (nextline =~ '^\~\+$') && (prevline =~ '^\s*$')
			let depth = 4
		endif

		if (line =~ '^.\+$') && (nextline =~ '^^\+$') && (prevline =~ '^\s*$')
			let depth = 5
		endif

		if (line =~ '^.\+$') && (nextline =~ '^+\+$') && (prevline =~ '^\s*$')
			let depth = 5
		endif
	endif


	if depth > 0
		if depth > 1
			let depth -= 1
		endif
		" check syntax, it should be asciidoctorTitle or asciidoctorH
		let syncode = synstack(v:lnum, 1)
		if len(syncode) > 0 && synIDattr(syncode[0], 'name') =~ 'asciidoctor\%(H[1-6]\)\|Title'
			return ">" . depth
		endif
	endif

	" Fold options
	if s:asciidoctor_fold_options
		if (line =~ '^:[[:alnum:]-!]\{-}:.*$')
			let prevline = getline(v:lnum - 1)
			if (prevline !~ '^:[[:alnum:]-!]\{-}:.*$')
				return "a1"
			endif
			let nextline = getline(v:lnum + 1)
			if (nextline !~ '^:[[:alnum:]-!]\{-}:.*$')
				return "s1"
			endif
		endif
	endif

	return "="
endfunction "}}}

" Use vim-dispatch if available
if exists(':Make') == 2
	let s:make = ':Make'
else
	let s:make = ':make'
endif

exe 'command! -buffer Asciidoctor2PDF :compiler asciidoctor2pdf | '   . s:make
exe 'command! -buffer Asciidoctor2HTML :compiler asciidoctor2html | ' . s:make
exe 'command! -buffer Asciidoctor2DOCX :compiler asciidoctor2docx | ' . s:make

func! s:get_fname(...)
	let ext = get(a:, 1, '')
	if ext == ''
		return expand("%:p")
	else
		return expand("%:p:r").ext
	endif
endfunc

func! s:open_file(filename)
	if filereadable(a:filename)
		exe g:asciidoctor_opener . ' ' . shellescape(a:filename)
	else
		echom a:filename . " doesn't exist!"
	endif
endfunc

command! -buffer AsciidoctorOpenRAW  call s:open_file(s:get_fname())
command! -buffer AsciidoctorOpenPDF  call s:open_file(s:get_fname(".pdf"))
command! -buffer AsciidoctorOpenHTML call s:open_file(s:get_fname(".html"))
command! -buffer AsciidoctorOpenDOCX call s:open_file(s:get_fname(".docx"))

if has("folding") && get(g:, 'asciidoctor_folding', 0)
	setlocal foldexpr=AsciidoctorFold()
	setlocal foldmethod=expr
	let b:undo_ftplugin .= " foldexpr< foldmethod<"
	let s:asciidoctor_fold_options = get(g:, 'asciidoctor_fold_options', 0)
endif

if get(g:, 'asciidoctor_img_paste_command', '') == ''
	" first `%s` is a path
	" second `%s` is an image file name
	if has('win32')
		let g:asciidoctor_img_paste_command = 'gm convert clipboard: %s%s'
	elseif has('osx')
		let g:asciidoctor_img_paste_command = 'pngpaste %s%s'
	else " there is probably a better tool for linux?
		let g:asciidoctor_img_paste_command = 'gm convert clipboard: %s%s'
	endif
endif

if get(g:, 'asciidoctor_img_paste_pattern', '') == ''
	" first `%s` is a base document name:
	" (~/docs/hello-world.adoc => hello-world)
	" second `%s` is a number of the image.
	let g:asciidoctor_img_paste_pattern = 'img_%s_%s.png'
endif

command! -buffer AsciidoctorPasteImage :call asciidoctor#pasteImage()


"" Next/Previous section mappings
fun! s:section(back, cnt)
  for n in range(a:cnt)
    call search('^=\+\s\+\S\+\|\_^\%(\n\|\%^\)\@<=\k.*\n\%(==\+\|\-\-\+\|\~\~\+\|\^\^\+\|++\+\)$', a:back ? 'bW' : 'W')
  endfor
endfun

nnoremap <silent><buffer> ]] :<c-u>call <sid>section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call <sid>section(1, v:count1)<CR>
xmap     <buffer><expr>   ]] "\<esc>".v:count1.']]m>gv'
xmap     <buffer><expr>   [[ "\<esc>".v:count1.'[[m>gv'

"" Detect default source code language
call asciidoctor#detect_source_language()

augroup asciidoctor_source_language
	au!
	au bufwrite *.adoc,*.asciidoc call asciidoctor#refresh_source_language_hl()
augroup END

"" Set completefunc
setl completefunc=asciidoctor#complete_bibliography
