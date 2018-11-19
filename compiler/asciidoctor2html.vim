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

let &l:makeprg = g:asciidoctor_executable." ".b:extensions." -a docdate=".strftime("%Y-%m-%d")." -a doctime=".strftime("%T")." ".shellescape(expand("%:p"))

let &cpo = s:keepcpo
unlet s:keepcpo

