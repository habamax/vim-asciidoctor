" Vim filetype plugin
" Language:	asciidoctor
" Maintainer:	Maxim Kim <habamax@gmail.com>
" Last Change:	2018-11-29

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

	" Fold options
	if g:asciidoctor_fold_options
		if (line =~ '^:[[:alnum:]-]\{-}:.*$')
			let prevline = getline(v:lnum - 1)
			if (prevline !~ '^:[[:alnum:]-]\{-}:.*$')
				return "a1"
			endif
			let nextline = getline(v:lnum + 1)
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

" To be moved to another file?
" Set default values for g:asciidoctor_img_paste_command

" Return name of an image directory.
"
" It is either 
" * '' (empty)
" * or value of :imagesdir: (stated at the top of the buffer)
fun! s:asciidoctorImagesDir()
	return 'images/'
endfu

" Return full path of an image
"
" It is 'current buffer path'/:imagesdir:
fun! s:asciidoctorImagesPath()
	return expand('%:p:h').'/'.s:asciidoctorImagesDir()
endfu

" Return list of generated images for the current buffer.
"
" If buffer name is `document.adoc`, search in a given path for the file
" pattern `img_document_N.png`, where N is a number.
"
" Example:
" `img_document_1.png`
" `img_document_2.png`
fun! s:asciidoctorListImages(path)
	let globpattern = 'img_'.expand('%:t:r').'_*'
	let filterpattern = 'img_'.expand('%:t:r').'_[[:digit:]]\+\.png$'
	let images = globpath(a:path, globpattern, 0, 1)
	return filter(images, {k,v -> v =~ filterpattern})
endfu

" Return index of the image file name
"
" `img_document_23.png` --> 23
" `img_document.png` --> 0 
" `any other` --> 0 
fun! s:asciidoctorExtractIndex(filename)
	let index = matchstr(a:filename, 'img_.*_\zs[[:digit:]]\+\ze\.png$')
	if index == ''
		let index = '0'
	endif
	return str2nr(index)
endfu

" Return new image name
"
" Having the list of images in a give path:
" `img_document_1.png`
" `img_document_2.png`
" ...
" Generate a new image name:
" `img_document_3.png
fun! s:asciidoctorGenerateImageName(path)
	let index = max(map(s:asciidoctorListImages(a:path), 
				\{k,v -> s:asciidoctorExtractIndex(v)})) + 1
	return 'img_'.expand('%:t:r').'_'.index.'.png'
endfu

" Paste image from the clipboard.
"
" * Save image as png file to the :imagesdir:
" * Insert `image::link.png[]` at cursor position
fun! s:asciidoctorPasteImage()
	let path = s:asciidoctorImagesPath()
	if !isdirectory(path)
		echoerr 'Image directory '.path.' doesn''t exist!'
		return
	endif

	let fname = s:asciidoctorGenerateImageName(path)

	" exe ":!gm convert clipboard: ".fname
	let job = job_start(printf(g:asciidoctor_img_paste_command, path, fname))

	let sav_reg_x = @x
	let @x = printf('image::%s[]', fname)
	put x
	let @x = sav_reg_x
endfu

command! -buffer AsciidoctorPasteImage :call <sid>asciidoctorPasteImage()
