" Vim compiler file
" Compiler: Asciidoctor2HTML
" Maintainer: Maxim Kim (habamax@gmail.com)

if exists("current_compiler")
  finish
endif
let current_compiler = "Asciidoctor2HTML"
let s:keepcpo= &cpo
set cpo&vim

if !exists("g:asciidoctor_extensions") || empty(g:asciidoctor_extensions)
	let s:extensions = ""
else
	let s:extensions = "-r ".join(g:asciidoctor_extensions, ' -r ')
endif

if !exists("g:asciidoctor_executable")
	let g:asciidoctor_executable = "asciidoctor"
endif

if !exists("g:asciidoctor_css_path") || g:asciidoctor_css_path == ''
	let s:css_path = ""
else
	let s:css_path = '-a stylesdir='.shellescape(expand(g:asciidoctor_css_path))
endif

if !exists("g:asciidoctor_css") || g:asciidoctor_css == ''
	let s:css_name = ""
else
	let s:css_name = '-a stylesheet='.shellescape(expand(g:asciidoctor_css))
endif

let &l:makeprg = g:asciidoctor_executable." ".s:extensions." -a docdate=".strftime("%Y-%m-%d")." -a doctime=".strftime("%T")." ".s:css_path." ".s:css_name." ".shellescape(expand("%:p"))

let &cpo = s:keepcpo
unlet s:keepcpo

