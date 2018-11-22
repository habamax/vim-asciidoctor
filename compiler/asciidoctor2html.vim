" Vim compiler file
" Compiler: Asciidoctor2HTML
" Maintainer: Maxim Kim (habamax@gmail.com)

if exists("current_compiler")
  finish
endif
let current_compiler = "Asciidoctor2HTML"
let s:keepcpo= &cpo
set cpo&vim

if exists("g:asciidoctor_extensions")
	let b:extensions = "-r ".join(g:asciidoctor_extensions, ' -r ')
endif

if !exists("g:asciidoctor_executable")
	let g:asciidoctor_executable = "asciidoctor"
endif

if !exists("g:asciidoctor_css_path")
	let b:css_path = ""
else
	let b:css_path = '-a stylesdir="'.shellescape(expand(g:asciidoctor_css_path)).'"'
endif

if !exists("g:asciidoctor_css")
	let b:css_name = ""
else
	let b:css_name = '-a stylesheet='.shellescape(expand(g:asciidoctor_css))
endif

let &l:makeprg = g:asciidoctor_executable." ".b:extensions." -a docdate=".strftime("%Y-%m-%d")." -a doctime=".strftime("%T")." ".b:css_path." ".b:css_name." ".shellescape(expand("%:p"))

let &cpo = s:keepcpo
unlet s:keepcpo

