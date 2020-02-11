" Vim compiler file
" Compiler: Asciidoctor 2 DOCX using docbook intermediate format and pandoc
" Maintainer: Maxim Kim (habamax@gmail.com)
" vim: et sw=4

if exists("current_compiler")
    finish
endif
let current_compiler = "Asciidoctor2DOCX"
let s:keepcpo= &cpo
set cpo&vim

if get(g:, 'asciidoctor_extensions', []) == []
    let s:extensions = ""
else
    let s:extensions = "-r ".join(g:asciidoctor_extensions, ' -r ')
endif

if get(g:, 'asciidoctor_executable', '') == ''
    let g:asciidoctor_executable = "asciidoctor"
endif

if get(g:, 'asciidoctor_pandoc_executable', '') == ''
    let g:asciidoctor_pandoc_executable = "pandoc"
endif

let s:make_docbook = g:asciidoctor_executable." ".s:extensions
            \. " -a docdate=".strftime("%Y-%m-%d")
            \. " -a doctime=".strftime("%T")
            \. " -b docbook"
            \. " ".shellescape(expand("%:p"))

let s:make_docx = g:asciidoctor_pandoc_executable
            \. " -f docbook -t docx"
            \. " -o " . shellescape(expand("%:p:r").".docx")
            \. " " . shellescape(expand("%:p:r").".xml")

let s:cd = "cd ".expand("%:p:h")
let &l:makeprg = s:make_docbook . " && " . s:cd ." && ". s:make_docx

let &cpo = s:keepcpo
unlet s:keepcpo
