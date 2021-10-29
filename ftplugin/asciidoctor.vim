" Vim filetype plugin
" Language:   asciidoctor
" Maintainer: Maxim Kim <habamax@gmail.com>
" Filenames:  *.adoc
" vim: et sw=4

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

let s:undo_opts = "setl cms< com< fo< flp< inex< efm< cfu< fde< fdm<"
let s:undo_cmds = "| delcommand Asciidoctor2PDF"
      \. "| delcommand Asciidoctor2HTML"
      \. "| delcommand Asciidoctor2DOCX"
      \. "| delcommand AsciidoctorOpenRAW"
      \. "| delcommand AsciidoctorOpenPDF"
      \. "| delcommand AsciidoctorOpenHTML"
      \. "| delcommand AsciidoctorOpenDOCX"
      \. "| delcommand AsciidoctorPasteImage"
let s:undo_maps = "| execute 'nunmap <buffer> ]]'"
      \. "| execute 'nunmap <buffer> [['"
      \. "| execute 'xunmap <buffer> ]]'"
      \. "| execute 'xunmap <buffer> [['"
      \. "| execute 'ounmap <buffer> ih'"
      \. "| execute 'ounmap <buffer> ah'"
      \. "| execute 'xunmap <buffer> ih'"
      \. "| execute 'xunmap <buffer> ah'"
      \. "| execute 'ounmap <buffer> il'"
      \. "| execute 'ounmap <buffer> al'"
      \. "| execute 'xunmap <buffer> il'"
      \. "| execute 'xunmap <buffer> al'"
      \. "| execute 'nunmap <buffer> gx'"
      \. "| execute 'nunmap <buffer> gf'"
      \. "| execute 'nunmap <buffer> <Plug>(AsciidoctorFold)'"
      \. "| execute 'nunmap <buffer> <Plug>(AsciidoctorSectionPromote)'"
      \. "| execute 'nunmap <buffer> <Plug>(AsciidoctorSectionDemote)'"
let s:undo_vars = "| unlet! b:commentary_startofline"

if exists('b:undo_ftplugin')
    let b:undo_ftplugin .= "|" . s:undo_opts . s:undo_cmds . s:undo_maps . s:undo_vars
else
    let b:undo_ftplugin = s:undo_opts . s:undo_cmds . s:undo_maps . s:undo_vars
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

command! -buffer AsciidoctorOpenRAW  call asciidoctor#open_file(s:get_fname())
command! -buffer AsciidoctorOpenPDF  call asciidoctor#open_file(s:get_fname(".pdf"))
command! -buffer AsciidoctorOpenHTML call asciidoctor#open_file(s:get_fname(".html"))
command! -buffer AsciidoctorOpenDOCX call asciidoctor#open_file(s:get_fname(".docx"))

command! -buffer AsciidoctorPasteImage :call asciidoctor#pasteImage()



"""
""" Mappings
"""
nnoremap <silent><buffer> ]] :<c-u>call <sid>section(0, v:count1)<CR>
nnoremap <silent><buffer> [[ :<c-u>call <sid>section(1, v:count1)<CR>
xmap     <buffer><expr>   ]] "\<esc>".v:count1.']]m>gv'
xmap     <buffer><expr>   [[ "\<esc>".v:count1.'[[m>gv'

"" header textobject
onoremap <silent><buffer>ih :<C-u>call asciidoctor#header_textobj(v:true)<CR>
onoremap <silent><buffer>ah :<C-u>call asciidoctor#header_textobj(v:false)<CR>
xnoremap <silent><buffer>ih :<C-u>call asciidoctor#header_textobj(v:true)<CR>
xnoremap <silent><buffer>ah :<C-u>call asciidoctor#header_textobj(v:false)<CR>

"" delimited bLock textobject
onoremap <silent><buffer>il :<C-u>call asciidoctor#delimited_block_textobj(v:true)<CR>
onoremap <silent><buffer>al :<C-u>call asciidoctor#delimited_block_textobj(v:false)<CR>
xnoremap <silent><buffer>il :<C-u>call asciidoctor#delimited_block_textobj(v:true)<CR>
xnoremap <silent><buffer>al :<C-u>call asciidoctor#delimited_block_textobj(v:false)<CR>

nnoremap <silent><buffer> gx :<c-u>call asciidoctor#open_url()<CR>
nnoremap <silent><buffer> gf :<c-u>call asciidoctor#open_url("edit")<CR>

"" Useful with
""  let g:asciidoctor_folding = 1
""  let g:asciidoctor_foldnested = 0
""  let g:asciidoctor_foldtitle_as_h1 = 1
"" Fold up to count foldlevel in a special way:
""     * no count is provided, toggle current fold;
""     * count is n, open folds of up to foldlevel n.
func! s:asciidoctor_fold(count) abort
    if !get(g:, 'asciidoctor_folding', 0)
        return
    endif
    if a:count == 0
        normal! za
    else
        let &foldlevel = a:count
    endif
endfunc

"" fold up to v:count foldlevel in a special way
nnoremap <silent><buffer> <Plug>(AsciidoctorFold) :<C-u>call <sid>asciidoctor_fold(v:count)<CR>

"" promote/demote sections
nnoremap <silent><buffer> <Plug>(AsciidoctorSectionPromote) :<C-u>call asciidoctor#promote_section()<CR>
nnoremap <silent><buffer> <Plug>(AsciidoctorSectionDemote) :<C-u>call asciidoctor#demote_section()<CR>



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

        let nested = get(g:, "asciidoctor_foldnested", v:true)

        " Regular headers
        let depth = match(line, '\(^=\+\)\@<=\( .*$\)\@=')

        " Do not fold nested regular headers
        if depth > 1 && !nested
            let depth = 1
        endif

        " Setext style headings
        if depth < 0
            let prevline = getline(v:lnum - 1)
            let nextline = getline(v:lnum + 1)

            if (line =~ '^.\+$') && (nextline =~ '^=\+$') && (prevline =~ '^\s*$')
                let depth = nested ? 2 : 1
            endif

            if (line =~ '^.\+$') && (nextline =~ '^-\+$') && (prevline =~ '^\s*$')
                let depth = nested ? 3 : 1
            endif

            if (line =~ '^.\+$') && (nextline =~ '^\~\+$') && (prevline =~ '^\s*$')
                let depth = nested ? 4 : 1
            endif

            if (line =~ '^.\+$') && (nextline =~ '^^\+$') && (prevline =~ '^\s*$')
                let depth = nested ? 5 : 1
            endif

            if (line =~ '^.\+$') && (nextline =~ '^+\+$') && (prevline =~ '^\s*$')
                let depth = nested ? 5 : 1
            endif
        endif


        if depth > 0
            " fold all sections under title
            if depth > 1 && get(g:, "asciidoctor_foldtitle_as_h1", v:true)
                let depth -= 1
            endif
            " check syntax, it should be asciidoctorTitle or asciidoctorH
            let syncode = synstack(v:lnum, 1)
            if len(syncode) > 0 && synIDattr(syncode[0], 'name') =~ 'asciidoctor\%(H[1-6]\)\|Title\|SetextHeader'
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


"" Next/Previous section mappings
func! s:section(back, cnt)
  for n in range(a:cnt)
    call search('^=\+\s\+\S\+\|\_^\%(\n\|\%^\)\@<=\k.*\n\%(==\+\|\-\-\+\|\~\~\+\|\^\^\+\|++\+\)$', a:back ? 'bW' : 'W')
  endfor
endfunc
