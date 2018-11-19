" Vim compiler file
" Compiler: Asciidoctor2PDF
" Maintainer: Maxim Kim (habamax@gmail.com)

if exists("current_compiler")
	finish
endif
let current_compiler = "Asciidoctor2PDF"
let s:keepcpo= &cpo
set cpo&vim

let b:pdf_styles = '-a pdf-stylesdir='.shellescape(expand(g:asciidoctor_pdf_themes_path))
let b:pdf_fonts = '-a pdf-fontsdir='.shellescape(expand(g:asciidoctor_pdf_fonts_path))

if exists("g:asciidoctor_pdf_extensions")
	let b:extensions = "-r ".join(g:asciidoctor_pdf_extensions, ' -r ')
endif

if !exists("g:asciidoctor_pdf_executable")
	let g:asciidoctor_pdf_executable = "asciidoctor-pdf"
endif

let &l:makeprg = g:asciidoctor_pdf_executable." ".b:extensions." -a docdate=".strftime("%Y-%m-%d")." -a doctime=".strftime("%T")." ".b:pdf_styles." ".b:pdf_fonts." ".shellescape(expand("%:p"))

let &cpo = s:keepcpo
unlet s:keepcpo

