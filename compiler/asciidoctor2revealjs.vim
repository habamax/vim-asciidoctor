" Vim compiler file
" Compiler: Asciidoctor2Revealjs
" Maintainer: Maxim Kim (habamax@gmail.com)
" vim: et sw=4

if exists("current_compiler")
  finish
endif
let current_compiler = "Asciidoctor2Revealjs"
let s:keepcpo= &cpo
set cpo&vim

if get(g:, 'asciidoctor_revealjs_extensions', []) == []
    let s:extensions = ""
else
    let s:extensions = "-r ".join(g:asciidoctor_revealjs_extensions, ' -r ')
endif

if get(g:, 'asciidoctor_revealjs_revealjs_theme', '') == ''
    let s:revealjs_theme = ""
else
    let s:revealjs_theme = '-a revealjs_theme='.shellescape(fnamemodify(g:asciidoctor_revealjs_revealjs_theme, ":p:h"))
endif

if get(g:, 'asciidoctor_revealjs_revealjs_customtheme', '') == ''
    let s:revealjs_customtheme = ""
else
    let s:revealjs_customtheme = '-a revealjs_customtheme='.shellescape(fnamemodify(g:asciidoctor_revealjs_revealjs_customtheme, ":p:h"))
endif

if get(g:, 'asciidoctor_revealjs_highlightjs_theme', '') == ''
    let s:highlightjs_theme = ""
else
    let s:highlightjs_theme = '-a highlightjs-theme='.shellescape(fnamemodify(g:asciidoctor_revealjs_highlightjs_theme, ":p:h"))
endif

if get(g:, 'asciidoctor_revealjs_revealjsdir', '') == ''
    let s:revealjsdir = ""
else
    let s:revealjsdir = '-a revealjsdir='.shellescape(fnamemodify(g:asciidoctor_revealjs_revealjsdir, ":p:h"))
endif

let s:asciidoctor_revealjs_executable = get(g:, 'asciidoctor_revealjs_executable', 'asciidoctor-revealjs')

let s:filename = shellescape(get(g:, 'asciidoctor_use_fullpath', v:true) ? expand("%:p") : expand("%:t"))

let &l:makeprg = s:asciidoctor_revealjs_executable . " " . s:extensions
            \. " -a docdate=".strftime("%Y-%m-%d")
            \. " -a doctime=".strftime("%T") . " "
            \. s:revealjs_theme . " "
            \. s:revealjs_customtheme . " "
            \. s:highlightjs_theme . " "
            \. s:revealjsdir . " "
            \. s:filename

let &cpo = s:keepcpo
unlet s:keepcpo
