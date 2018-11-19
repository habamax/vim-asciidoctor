" Vim filetype plugin
" Language:	asciidoctor
" Maintainer:	Maxim Kim <habamax@gmail.com>
" Last Change:	2018-11-01

if exists("b:did_ftplugin")
	finish
endif

compiler Asciidoctor2HTML

" open files
if !exists('g:asciidoctor_opener') || g:asciidoctor_opener == ''
	if has("win32")
		let g:asciidoctor_opener = ":!start"
	elseif has("osx")
		let g:asciidoctor_opener = ":!open"
	elseif has("win32unix")
		let g:asciidoctor_opener = ":!start"
	else
		let g:asciidoctor_opener = ":!firefox"
	endif
endif

" gf to open include files
setlocal includeexpr=substitute(v:fname,'include::\\(.\\{-}\\)\\[.*','\\1','g')
setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=//\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= "|setl cms< com< fo< flp< inex<"
else
	let b:undo_ftplugin = "setl cms< com< fo< flp< inex<"
endif

function! AsciidoctorFold() "{{{
	let line = getline(v:lnum)

	" Regular headers
	let depth = match(line, '\(^=\+\)\@<=\( .*$\)\@=')
	if depth > 0
		if depth > 1
			let depth -= 1
		endif
		return ">" . depth
	endif

	if g:asciidoctor_fold_options
		" Fold options
		let prevline = getline(v:lnum - 1)
		if (line =~ '^:[[:alnum:]-]\{-}:.*$')
			if (prevline !~ '^:[[:alnum:]-]\{-}:.*$')
				return "a1"
			endif
			if (nextline !~ '^:[[:alnum:]-]\{-}:.*$')
				return "s1"
			endif
		endif
	endif

	return "="
endfunction "}}}

command! -buffer Asciidoctor2PDF :compiler asciidoctor2pdf | :make
command! -buffer Asciidoctor2HTML :compiler asciidoctor2html | :make
command! -buffer Asciidoctor2DOCX :compiler asciidoctor2docx | :make

command! -buffer AsciidoctorOpenRAW :exe g:asciidoctor_opener." ".expand("%:p")
command! -buffer AsciidoctorOpenPDF :exe g:asciidoctor_opener." ".expand("%:p:r").".pdf"
command! -buffer AsciidoctorOpenHTML :exe g:asciidoctor_opener." ".expand("%:p:r").".html"
command! -buffer AsciidoctorOpenDOCX :exe g:asciidoctor_opener." ".expand("%:p:r").".docx"

if has("folding") && exists("g:asciidoctor_folding")
	if g:asciidoctor_folding
		setlocal foldexpr=AsciidoctorFold()
		setlocal foldmethod=expr
		if !exists('g:asciidoctor_fold_options')
			let g:asciidoctor_fold_options = 0
		endif
		let b:undo_ftplugin .= " foldexpr< foldmethod<"
	endif
endif
