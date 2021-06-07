" Vim filetype plugin
" Language:   asciidoctor
" Maintainer: Maxim Kim <habamax@gmail.com>
" Filenames:  *.adoc
" vim: et sw=4

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1


if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|setl cms< com< fo< flp< inex< efm< cfu<"
else
    let b:undo_ftplugin = "setl cms< com< fo< flp< inex< efm< cfu<"
endif


" see https://github.com/asciidoctor/asciidoctor-pdf/issues/1273
setlocal errorformat=asciidoctor:\ ERROR:\ %f:\ line\ %l:\ %m

" gf to open include::file.ext[] and link:file.ext[] files
setlocal includeexpr=substitute(v:fname,'\\(link:\\\|include::\\)\\(.\\{-}\\)\\[.*','\\2','g')
setlocal comments=
setlocal commentstring=//\ %s
" vim-commentary plugin setup
let b:commentary_startofline = 1

setlocal formatoptions+=cqn
setlocal formatlistpat=^\\s*
setlocal formatlistpat+=[
setlocal formatlistpat+=\\[({]\\?
setlocal formatlistpat+=\\(
setlocal formatlistpat+=[0-9]\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=[a-zA-Z]
setlocal formatlistpat+=\\)
setlocal formatlistpat+=[\\]:.)}
setlocal formatlistpat+=]
setlocal formatlistpat+=\\s\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=^\\s*-\\s\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=^\\s*[*]\\+\\s\\+
setlocal formatlistpat+=\\\|
setlocal formatlistpat+=^\\s*[.]\\+\\s\\+

setlocal completefunc=asciidoctor#complete_bibliography


"""
""" Commands
"""
" Use vim-dispatch if available
if exists(':Make') == 2
    let s:make = ':Make'
else
    let s:make = ':make'
endif

exe 'command! -buffer Asciidoctor2PDF :compiler asciidoctor2pdf | '   . s:make
exe 'command! -buffer Asciidoctor2HTML :compiler asciidoctor2html | ' . s:make
exe 'command! -buffer Asciidoctor2DOCX :compiler asciidoctor2docx | ' . s:make

command! -buffer AsciidoctorOpenRAW  call s:open_file(s:get_fname())
command! -buffer AsciidoctorOpenPDF  call s:open_file(s:get_fname(".pdf"))
command! -buffer AsciidoctorOpenHTML call s:open_file(s:get_fname(".html"))
command! -buffer AsciidoctorOpenDOCX call s:open_file(s:get_fname(".docx"))

command! -buffer AsciidoctorPasteImage :call asciidoctor#pasteImage()



"""
""" Mappings
"""
nnoremap <silent><buffer> ]] :<c-u>call <sid>section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call <sid>section(1, v:count1)<CR>
xmap     <buffer><expr>   ]] "\<esc>".v:count1.']]m>gv'
xmap     <buffer><expr>   [[ "\<esc>".v:count1.'[[m>gv'

"" header textobject
onoremap <silent>ih :<C-u>call asciidoctor#header_textobj(v:true)<CR>
onoremap <silent>ah :<C-u>call asciidoctor#header_textobj(v:false)<CR>
xnoremap <silent>ih :<C-u>call asciidoctor#header_textobj(v:true)<CR>
xnoremap <silent>ah :<C-u>call asciidoctor#header_textobj(v:false)<CR>

"" delimited bLock textobject
onoremap <silent>il :<C-u>call asciidoctor#delimited_block_textobj(v:true)<CR>
onoremap <silent>al :<C-u>call asciidoctor#delimited_block_textobj(v:false)<CR>
xnoremap <silent>il :<C-u>call asciidoctor#delimited_block_textobj(v:true)<CR>
xnoremap <silent>al :<C-u>call asciidoctor#delimited_block_textobj(v:false)<CR>

nnoremap <silent><buffer> gx :<c-u>call <sid>open_url()<CR>



"""
""" Global options processing
"""
if get(g:, 'asciidoctor_opener', '') == ''
    if has("win32") || has("win32unix")
        if has("nvim")
            let g:asciidoctor_opener = ':silent !start ""'
        else
            let g:asciidoctor_opener = ':silent !start'
        endif
    elseif has("osx")
        let g:asciidoctor_opener = ":!open"
    elseif exists("$WSLENV")
        let g:asciidoctor_opener = ":silent !cmd.exe /C start"
    else
        let g:asciidoctor_opener = ":!xdg-open"
    endif
endif


if has("folding") && get(g:, 'asciidoctor_folding', 0)
    function! AsciidoctorFold() "{{{
        let line = getline(v:lnum)

        if (v:lnum == 1) && (line =~ '^----*$')
           return ">1"
        endif

        " Regular headers
        let depth = match(line, '\(^=\+\)\@<=\( .*$\)\@=')

        " Setext style headings
        if depth < 0
            let prevline = getline(v:lnum - 1)
            let nextline = getline(v:lnum + 1)

            if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
                let depth = 2
            endif

            if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
                let depth = 3
            endif

            if (line =~ '^.\+$') && (nextline =~ '^\~\+$') && (prevline =~ '^\s*$')
                let depth = 4
            endif

            if (line =~ '^.\+$') && (nextline =~ '^^\+$') && (prevline =~ '^\s*$')
                let depth = 5
            endif

            if (line =~ '^.\+$') && (nextline =~ '^+\+$') && (prevline =~ '^\s*$')
                let depth = 5
            endif
        endif


        if depth > 0
            if depth > 1
                let depth -= 1
            endif
            " check syntax, it should be asciidoctorTitle or asciidoctorH
            let syncode = synstack(v:lnum, 1)
            if len(syncode) > 0 && synIDattr(syncode[0], 'name') =~ 'asciidoctor\%(H[1-6]\)\|Title'
                return ">" . depth
            endif
        endif

        " Fold options
        if s:asciidoctor_fold_options
            let opt_regex = '^:[[:alnum:]-!]\{-}:.*$'
            if (line =~ opt_regex)
                let prevline = getline(v:lnum - 1)
                let nextline = getline(v:lnum + 1)
                if (prevline !~ opt_regex) && (nextline =~ opt_regex)
                    return "a1"
                endif
                if (nextline !~ opt_regex) && (prevline =~ opt_regex)
                    return "s1"
                endif
            endif
        endif

        return "="
    endfunction "}}}

    setlocal foldexpr=AsciidoctorFold()
    setlocal foldmethod=expr
    let b:undo_ftplugin .= " foldexpr< foldmethod<"
    let s:asciidoctor_fold_options = get(g:, 'asciidoctor_fold_options', 0)
endif


if get(g:, 'asciidoctor_img_paste_command', '') == ''
    " first `%s` is a path
    " second `%s` is an image file name
    if has('win32')
        let g:asciidoctor_img_paste_command = 'gm convert clipboard: %s%s'
    elseif has('osx')
        let g:asciidoctor_img_paste_command = 'pngpaste %s%s'
    else " there is probably a better tool for linux?
        let g:asciidoctor_img_paste_command = 'gm convert clipboard: %s%s'
    endif
endif


if get(g:, 'asciidoctor_img_paste_pattern', '') == ''
    " first `%s` is a base document name:
    " (~/docs/hello-world.adoc => hello-world)
    " second `%s` is a number of the image.
    let g:asciidoctor_img_paste_pattern = 'img_%s_%s.png'
endif



"""
""" Detect default source code language
"""
call asciidoctor#detect_source_language()

augroup asciidoctor_source_language
    au!
    au bufwrite *.adoc,*.asciidoc call asciidoctor#refresh_source_language_hl()
augroup END



"""
""" Helper functions
"""
func! s:get_fname(...)
    let ext = get(a:, 1, '')
    if ext == ''
        return expand("%")
    else
        return expand("%:r").ext
    endif
endfunc


"" Return Windows path from WSL
func! s:wsl_to_windows_path(path) abort
    if !exists("$WSLENV")
        return a:path
    endif

    if !executable('wslpath')
        return a:path
    endif

    let res = systemlist('wslpath -w ' . a:path)
    if !empty(res)
        return res[0]
    else
        return a:path
    endif
endfunc


func! s:open_file(filename)
    if filereadable(a:filename)
        if exists("$WSLENV")
            exe g:asciidoctor_opener . ' '
                        \ . shellescape(s:wsl_to_windows_path(a:filename))
        else
            exe g:asciidoctor_opener . ' ' . shellescape(a:filename)
        endif
    else
        echom a:filename . " doesn't exist!"
    endif
endfunc


"" to open URLs with gx mapping
func! s:open_url()
    " by default check WORD under cursor
    let word = expand("<cWORD>")

    " But if cursor is surrounded by [   ], like for http://ya.ru[yandex search]
    " take a cWORD from first char before [
    let save_cursor = getcurpos()
    let line = getline('.')
    if searchpair('\[', '', '\]', 'b', '', line('.')) 
        let word = expand("<cWORD>")
    endif
    call setpos('.', save_cursor)

    " Check asciidoc URL http://bla-bla.com[desc
    let aURL = matchstr(word, '\%(\%(http\|ftp\|irc\)s\?\|file\)://\S\+\ze\[')
    if aURL != ""
        exe g:asciidoctor_opener . ' ' . escape(aURL, '#%!')
        return
    endif

    " Check asciidoc link link:file.txt[desc
    let aLNK = matchstr(word, 'link:/*\zs\S\+\ze\[')
    if aLNK != ""
        execute "lcd ". expand("%:p:h")
        exe g:asciidoctor_opener . ' ' . fnameescape(fnamemodify(aLNK, ":p"))
        lcd -
        return
    endif

    " Check asciidoc URL http://bla-bla.com
    let URL = matchstr(word, '\%(\%(http\|ftp\|irc\)s\?\|file\)://\S\+')
    if URL != ""
        exe g:asciidoctor_opener . ' ' . escape(URL, '#%!')
        return
    endif

    " probably path?
    if word =~ '^[~.$].*'
        exe g:asciidoctor_opener . ' ' . expand(word)
        return
    endif
endfunc


"" Next/Previous section mappings
fun! s:section(back, cnt)
  for n in range(a:cnt)
    call search('^=\+\s\+\S\+\|\_^\%(\n\|\%^\)\@<=\k.*\n\%(==\+\|\-\-\+\|\~\~\+\|\^\^\+\|++\+\)$', a:back ? 'bW' : 'W')
  endfor
endfun
