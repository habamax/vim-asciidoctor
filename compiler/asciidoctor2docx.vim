" Vim compiler file
" Compiler: Asciidoctor 2 DOCX using docbook intermediate format and pandoc
" Maintainer: Maxim Kim (habamax@gmail.com)

if exists("current_compiler")
	finish
endif
let current_compiler = "Asciidoctor2DOCX"
let s:keepcpo= &cpo
set cpo&vim

if exists("g:asciidoctor_extensions")
	let b:extensions = "-r ".join(g:asciidoctor_extensions, ' -r ')
endif

if !exists("g:asciidoctor_executable")
	let g:asciidoctor_executable = "asciidoctor"
endif

if !exists("g:asciidoctor_pandoc_executable")
	let g:asciidoctor_pandoc_executable = "pandoc"
endif

let b:make_docbook = g:asciidoctor_executable." ".b:extensions.
			\" -a docdate=".strftime("%Y-%m-%d").
			\" -a doctime=".strftime("%T").
			\" -b docbook".
			\" ".shellescape(expand("%:p"))

let b:make_docx = g:asciidoctor_pandoc_executable.
			\" -f docbook -t docx".
			\" -o ".expand("%:p:r").".docx".
			\" ".expand("%:p:r").".xml"

let &l:makeprg = b:make_docbook ." && ". b:make_docx

let &cpo = s:keepcpo
unlet s:keepcpo

