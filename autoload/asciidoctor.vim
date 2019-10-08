if exists("g:loaded_asciidoctor_autoload")
    finish
endif
let g:loaded_asciidoctor_autoload = 1


" Return name of an image directory.
"
" It is either 
" * '' (empty)
" * or value of :imagesdir: (stated at the top of the buffer, first 50 lines)
fun! s:asciidoctorImagesDir()
	let imagesdirs = filter(getline(1, 50), {k,v -> v =~ '^:imagesdir:.*'})
	if len(imagesdirs)>0
		return matchstr(imagesdirs[0], ':imagesdir:\s*\zs\f\+\ze$').'/'
	else
		return ''
	endif
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
" pattern `g:asciidoctor_img_paste_pattern`.
"
" Example:
" `img_document_1.png`
" `img_document_2.png`
fun! s:asciidoctorListImages(path)
	let globpattern = '*'.matchstr(g:asciidoctor_img_paste_pattern, '.*\zs\.\%(png\|jpg\)$')

	let rxpattern = '\V\[\\/]'.printf(g:asciidoctor_img_paste_pattern, expand('%:t:r'), '\d\+').'\$'
	let images = globpath(a:path, globpattern, 0, 1)
	return filter(images, {k,v -> v =~ rxpattern})
endfu

" Return index of the image file name
"
" `img_document_23.png` --> 23
" `img_document.png` --> 0 
" `any other` --> 0 
fun! s:asciidoctorExtractIndex(filename)
	let rxpattern = '\V\[\\/]'.printf(g:asciidoctor_img_paste_pattern, expand('%:t:r'), '\zs\d\+\ze').'\$'
	let index = matchstr(a:filename, rxpattern)
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
	return printf(g:asciidoctor_img_paste_pattern, expand('%:t:r'), index)
	
endfu

" Paste image from the clipboard.
"
" * Save image as png file to the :imagesdir:
" * Insert `image::link.png[]` at cursor position
fun! asciidoctor#pasteImage()
	let path = s:asciidoctorImagesPath()
	if !isdirectory(path)
		echoerr 'Image directory '.path.' doesn''t exist!'
		return
	endif

	let fname = s:asciidoctorGenerateImageName(path)

	let fargs = printf(g:asciidoctor_img_paste_command, path, fname)

	if has('nvim')
		let Jobfunc = function('jobstart')
	else
		let Jobfunc = function('job_start')
	endif
	call Jobfunc(fargs)

	let sav_reg_x = @x
	let @x = printf('image::%s[]', fname)
	put x
	let @x = sav_reg_x
endfu


" Check header (20 lines) of the file for default source language
func! asciidoctor#detect_source_language()
	for line in getline(1, 20)
		let m = matchlist(line, '^:source-language: \(.*\)$')
		if !empty(m)
			let src_lang = trim(m[1])
			if src_lang != ''
				let b:asciidoctor_source_language = trim(m[1])
				break
			endif
		endif
	endfor
endfunc
