" Vim compiler file
" Compiler: Asciidoctor2PDF
" Maintainer: Maxim Kim (habamax@gmail.com)
" vim: set noet

if exists("current_compiler")
	finish
endif
let current_compiler = "Asciidoctor2PDF"
let s:keepcpo= &cpo
set cpo&vim

if get(g:, 'asciidoctor_pdf_themes_path', '') == ''
	let s:pdf_themes_path = ""
else
	let s:pdf_themes_path = '-a pdf-stylesdir='.shellescape(expand(g:asciidoctor_pdf_themes_path))
endif

if get(g:, 'asciidoctor_pdf_fonts_path', '') == ''
	let s:pdf_fonts_path = ""
else
	let s:pdf_fonts_path = '-a pdf-fontsdir='.shellescape(expand(g:asciidoctor_pdf_fonts_path))
endif

if get(g:, 'asciidoctor_pdf_extensions', []) == []
	let s:extensions = ""
else
	let s:extensions = "-r ".join(g:asciidoctor_pdf_extensions, ' -r ')
endif

if get(g:, 'asciidoctor_pdf_executable', '') == ''
	let g:asciidoctor_pdf_executable = "asciidoctor-pdf"
endif

let &l:makeprg = g:asciidoctor_pdf_executable . " " . s:extensions
			\. " -a docdate=" . strftime("%Y-%m-%d")
			\. " -a doctime=" . strftime("%H:%M:%S") . " "
			\. s:pdf_themes_path . " "
			\. s:pdf_fonts_path . " "
			\. shellescape(expand("%:p"))

let &cpo = s:keepcpo
unlet s:keepcpo

