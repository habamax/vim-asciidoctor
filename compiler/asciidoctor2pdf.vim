" Vim compiler file
" Compiler: Asciidoctor2PDF
" Maintainer: Maxim Kim (habamax@gmail.com)
" vim: et sw=4

if exists("current_compiler")
    finish
endif
" Use let g:asciidoctor_allow_uri_read = " -a allow-uri-read" in your .vimrc
" to enable including images from URIs.  Use this with care!  Refer:
" https://docs.asciidoctor.org/asciidoc/latest/directives/include-uri/
let g:asciidoctor_allow_uri_read = exists("g:asciidoctor_allow_uri_read") ? g:asciidoctor_allow_uri_read : ""
let current_compiler = "Asciidoctor2PDF"
let s:keepcpo= &cpo
set cpo&vim

"" check first non-empty lines of the asciidoctor buffer if theme 
"" is set up in file options
"" if not, don't provide themes and styles path to compiler to avoid errors
let s:use_pdf_paths = 0
for line in getline(1, 50)
    if line =~ "^\s*$"
        break
    endif
    if line =~ "^:pdf-theme:.*$"
        let s:use_pdf_paths = 1
        break
    endif
endfor

if get(g:, 'asciidoctor_pdf_themes_path', '') == '' || !get(s:, 'use_pdf_paths', 0)
    let s:pdf_themes_path = ""
else
    let s:pdf_themes_path = '-a pdf-themesdir='.shellescape(fnamemodify(g:asciidoctor_pdf_themes_path, ':p:h'))
endif

if get(g:, 'asciidoctor_pdf_fonts_path', '') == '' || !get(s:, 'use_pdf_paths', 0)
    let s:pdf_fonts_path = ""
else
    let s:pdf_fonts_path = '-a pdf-fontsdir='.shellescape(fnamemodify(g:asciidoctor_pdf_fonts_path, ':p:h'))
endif

if get(g:, 'asciidoctor_pdf_extensions', []) == []
    let s:extensions = ""
else
    let s:extensions = "-r ".join(g:asciidoctor_pdf_extensions, ' -r ')
endif

let s:asciidoctor_pdf_executable = get(g:, 'asciidoctor_pdf_executable', 'asciidoctor-pdf')

let s:filename = shellescape(get(g:, 'asciidoctor_use_fullpath', v:true) ? expand("%:p") : expand("%:t"))

let &l:makeprg = s:asciidoctor_pdf_executable . " " . s:extensions
            \. g:asciidoctor_allow_uri_read
            \. " -a docdate=" . strftime("%Y-%m-%d")
            \. " -a doctime=" . strftime("%H:%M:%S") . " "
            \. s:pdf_themes_path . " "
            \. s:pdf_fonts_path . " "
            \. s:filename

let &cpo = s:keepcpo
unlet s:keepcpo
