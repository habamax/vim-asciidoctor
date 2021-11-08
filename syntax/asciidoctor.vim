" Vim syntax file
" Language:     asciidoctor
" Maintainer:   Maxim Kim <habamax@gmail.com>
" Filenames:    *.adoc
" vim: et sw=4

if exists("b:current_syntax")
    finish
endif

syntax spell toplevel

if !exists('main_syntax')
    let main_syntax = 'asciidoctor'
endif

if !exists('g:asciidoctor_fenced_languages')
    let g:asciidoctor_fenced_languages = []
endif
for s:type in g:asciidoctor_fenced_languages + [get(b:, "asciidoctor_source_language", "NONE")]
    if s:type ==# "NONE"
        continue
    endif
    exe 'syn include @asciidoctorSourceHighlight'.s:type.' syntax/'.s:type.'.vim'
    unlet! b:current_syntax
endfor
unlet! s:type

if globpath(&rtp, "syntax/plantuml.vim") != ''
    syn include @asciidoctorPlantumlHighlight syntax/plantuml.vim
    unlet! b:current_syntax
endif

" Check :h syn-sync-fourth
syn sync maxlines=100

syn case ignore

syn match asciidoctorOption "^:[[:alnum:]!-]\{-}:"
syn match asciidoctorListContinuation "^+\s*$"
syn match asciidoctorPageBreak "^<<<\+\s*$"

syn cluster asciidoctorBlock contains=asciidoctorTitle,asciidoctorH1,asciidoctorH2,asciidoctorH3,asciidoctorH4,asciidoctorH5,asciidoctorH6,asciidoctorSetextHeader,asciidoctorSetextHeaderDelimiter,asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInnerBlock contains=asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorDefList,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInline contains=asciidoctorItalic,asciidoctorBold,asciidoctorCode,asciidoctorBoldItalic,asciidoctorUrl,asciidoctorUrlAuto,asciidoctorLink,asciidoctorAnchor,asciidoctorMacro,asciidoctorAttribute,asciidoctorInlineAnchor
syn cluster asciidoctorUrls contains=asciidoctorUrlDescription,asciidoctorFile,asciidoctorUrlAuto,asciidoctorEmailAuto

syn region asciidoctorTitle matchgroup=asciidoctorTitleDelimiter start="^=\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH1 matchgroup=asciidoctorH1Delimiter start="^==\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH2 matchgroup=asciidoctorH2Delimiter start="^===\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH3 matchgroup=asciidoctorH3Delimiter start="^====\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH4 matchgroup=asciidoctorH4Delimiter start="^=====\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH5 matchgroup=asciidoctorH5Delimiter start="^======\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell
syn region asciidoctorH6 matchgroup=asciidoctorH6Delimiter start="^=======\s" end="$" oneline keepend contains=@asciidoctorInline,@Spell

syn match asciidoctorSetextHeader '^\%(\n\|\%^\)\k.*\n\%(==\+\|\-\-\+\|\~\~\+\|\^\^\+\|++\+\)$' contains=@Spell,asciidoctorSetextHeaderDelimiter
syn match asciidoctorSetextHeaderDelimiter "^==\+\|\-\-\+\|\~\~\+\|\^\^\+\|++\+$" contained containedin=asciidoctorSetextHeader

syn sync clear
syn sync match syncH1 grouphere NONE "^==\s.*$"
syn sync match syncH2 grouphere NONE "^===\s.*$"
syn sync match syncH3 grouphere NONE "^====\s.*$"
syn sync match syncH4 grouphere NONE "^=====\s.*$"
syn sync match syncH5 grouphere NONE "^======\s.*$"
syn sync match syncH6 grouphere NONE "^=======\s.*$"

syn match asciidoctorAttribute "{[[:alpha:]][[:alnum:]-_:]\{-}}"

" a Macro is a generic pattern that has no default highlight, but it could contain a link/image/url/xref/mailto/etc, and naked URLs as well

syn match asciidoctorMacro "\<\l\{-1,}://\S\+" contains=asciidoctorUrlAuto,asciidoctorCode
syn match asciidoctorMacro "\<\w\S\{-}@\w\+\.\w\+" contains=asciidoctorEmailAuto,asciidoctorCode
syn match asciidoctorMacro "\<\l\{-1,}::\?\S*\[.\{-}\]" keepend contains=asciidoctorUrl,asciidoctorLink,asciidoctorEmail,asciidoctorCode

syn match asciidoctorFile "\f\+" contained
syn match asciidoctorUrlDescription "\[[^]]\{-}\]" contained containedin=asciidoctorLink
syn match asciidoctorUrlAuto "\%(file\|http\|ftp\|irc\)s\?://\S\+\%(\[.\{-}\]\)\?" contained contains=asciidoctorUrl
syn match asciidoctorEmailAuto "[a-zA-Z0-9._%+-]\{-1,}@\w\+\%(\.\w\+\)\+" contained

if get(g:, 'asciidoctor_syntax_conceal', 0)
    " the pattern \[\ze\%(\s*[^ ]\+\s*\)\+]\+ means: a brackets pair, inside of which at least one non-space character, possibly with spaces
    syn region asciidoctorLink matchgroup=Conceal start="\%(link\|xref\|mailto\|irc\):[^:][^\[]\{-}\[\ze\%(\s*[^ \]]\+\s*\)\+\]\+" end="\]" concealends oneline keepend skipwhite contained
    syn region asciidoctorLink matchgroup=Conceal start="\%(link\|xref\|mailto\|irc\):\ze[^:][^\[]\{-}\[\s*\]" end="\ze\[\s*\]" concealends oneline keepend skipwhite contained nextgroup=asciidoctorUrlDescription contains=asciidoctorUrl,asciidoctorFile

    syn region asciidoctorUrl matchgroup=Conceal start="\%(file\|http\|ftp\|irc\)s\?://\S\+\[\ze\%(\s*[^ ]\+\s*\)\+]\+" end="\]" concealends oneline keepend skipwhite contained

    if get(g:, 'asciidoctor_compact_media_links', 0)
        " conceal also the address of an image/video, if the description is not empty
        syn region asciidoctorLink matchgroup=Conceal start="\%(video\|image\)::\ze.*" end="\ze\[\s*\]" concealends oneline keepend skipwhite contained nextgroup=asciidoctorUrlDescription contains=asciidoctorUrl,asciidoctorFile
        syn region asciidoctorLink matchgroup=Conceal start="\%(video\|image\)::.*\[\ze\%(\s*[^ ]\+\s*\)\+]\+" end="\]" concealends oneline keepend skipwhite contained
    else
        syn region asciidoctorLink matchgroup=Conceal start="\%(video\|image\)::\?\ze.*" end="\ze\[.*\]" concealends oneline keepend skipwhite contained nextgroup=asciidoctorUrlDescription contains=asciidoctorFile
    endif

    syn region asciidoctorAnchor matchgroup=Conceal start="<<\%([^>]\{-},\s*\)\?\ze.\{-}>>" end=">>" concealends oneline

    syn region asciidoctorBold matchgroup=Conceal start=/\m\*\*/ end=/\*\*/ contains=@Spell concealends oneline
    syn region asciidoctorBold matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)\*\ze[^* ].\{-}\S/ end=/\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

    syn region asciidoctorItalic matchgroup=Conceal start=/\m__/ end=/__/ contains=@Spell concealends oneline
    syn region asciidoctorItalic matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)_\ze[^_ ].\{-}\S/ end=/_\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

    syn region asciidoctorBoldItalic matchgroup=Conceal start=/\m\*\*_/ end=/_\*\*/ contains=@Spell concealends oneline
    syn region asciidoctorBoldItalic matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)\*_\ze[^*_ ].\{-}\S/ end=/_\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

    syn region asciidoctorCode matchgroup=Conceal start=/\m``/ end=/``/ contains=@Spell concealends oneline
    syn region asciidoctorCode matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)`\ze[^` ].\{-}\S/ end=/`\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline
else
    syn region asciidoctorLink start="\%(link\|xref\|mailto\):\zs[^:].\{-}\ze\[" end="\[.\{-}\]" oneline keepend skipwhite contained
    syn region asciidoctorLink start="\%(video\|image\)::\?\zs.\{-}\ze\[" end="\[.\{-}\]" oneline keepend skipwhite contained
    syn match asciidoctorUrl "\%(file\|http\|ftp\|irc\)s\?://\S\+\ze\%(\[.\{-}\]\)" nextgroup=asciidoctorUrlDescription

    syn match asciidoctorAnchor "<<.\{-}>>"

    syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\@<=\)\*[^* ].\{-}\S\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    " single char *b* bold
    syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\@<=\)\*[^* ]\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    syn match asciidoctorBold /\*\*\S.\{-}\*\*/ contains=@Spell

    syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\@<=\)_[^_ ].\{-}\S_\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    " single char _b_ italic
    syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\@<=\)_[^_ ]_\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    syn match asciidoctorItalic /__\S.\{-}__/ contains=@Spell

    syn match asciidoctorBoldItalic /\%(^\|[[:punct:][:space:]]\@<=\)\*_[^*_ ].\{-}\S_\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    " single char *_b_* bold+italic
    syn match asciidoctorBoldItalic /\%(^\|[[:punct:][:space:]]\@<=\)\*_[^*_ ]_\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell
    syn match asciidoctorBoldItalic /\*\*_\S.\{-}_\*\*/ contains=@Spell

    syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\@<=\)`[^` ].\{-}\S`\%([[:punct:][:space:]]\@=\|$\)/
    " single char `c` code
    syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\@<=\)`[^` ]`\%([[:punct:][:space:]]\@=\|$\)/
    syn match asciidoctorCode /``.\{-}``/
endif

syn match asciidoctorUppercase /^\ze\u\+:/ nextgroup=asciidoctorAdmonition
syn match asciidoctorAdmonition /\C^\%(NOTE:\)\|\%(TIP:\)\|\%(IMPORTANT:\)\|\%(CAUTION:\)\|\%(WARNING:\)\s/ contained

syn match asciidoctorListMarker "^\s*\(-\|\*\+\|\.\+\)\%(\s\+\[[Xx ]\]\+\s*\)\?\%(\s\+\S\)\@="
syn match asciidoctorOrderedListMarker "^\s*\%(\d\+\|\a\)\.\%(\s\+\S\)\@="
syn match asciidoctorDefList "^.\{-}::\%(\s\|$\)" contains=@Spell

syn match asciidoctorCallout "\s\+\zs<\%(\.\|\d\+\)>\ze\s*$" contained
syn match asciidoctorCalloutDesc "^\s*\zs<\%(\.\|\d\+\)>\ze\s\+"


syn match asciidoctorCaption "^\.[^.[:space:]].*$" contains=@asciidoctorInline,@Spell

syn match asciidoctorBlockOptions "^\[.\{-}\]\s*$"

if get(g:, 'asciidoctor_syntax_indented', 1)
    syn match asciidoctorPlus '^+\n\s' contained
    syn match asciidoctorIndented '^+\?\n\%(\s\+\(-\|[*.]\+\|\d\+\.\|\a\.\)\s\)\@!\(\s.*\n\)\+' contains=asciidoctorPlus
endif

syn match asciidoctorInlineAnchor "\[\[.\{-}\]\]"

syn match asciidoctorIndexTerm "((.\{-}))"
syn match asciidoctorIndexTerm "(((.\{-})))"

" Open block
" --
" Should be highlighted as usual asciidoctor
" Except (at least) headings
" --
syn region asciidoctorOpenBlock matchgroup=asciidoctorBlock start="^--\s*$" end="^--\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment,asciidoctorIndented

" Listing block
" ----
" block that will not be
" highlighted
" ----
syn region asciidoctorListingBlock matchgroup=asciidoctorBlock start="^----\+\s*$" end="^----\s*$"

" General [source] block
syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*$" end="^\s*$" keepend
syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend
syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^```\%(\w\+\)\?\s*$" end="^.*\n\?\zs```\s*$" keepend

" Source highlighting with programming languages
if main_syntax ==# 'asciidoctor'

    "" if :source-language: is set up
    "" b:asciidoctor_source_language should be set up in ftplugin -- reading
    "" first 20(?) rows of a file
    if get(b:, "asciidoctor_source_language", "NONE") != "NONE"
        " :source-language: python
        "[source]
        " for i in ...
        "
        exe 'syn region asciidoctorSourceHighlightDefault'.b:asciidoctor_source_language.' matchgroup=asciidoctorBlock start="^\[source\]\s*$" end="^\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.b:asciidoctor_source_language

        " :source-language: python
        "[source]
        "----
        " for i in ...
        "----
        exe 'syn region asciidoctorSourceHighlightDefault'.b:asciidoctor_source_language.' matchgroup=asciidoctorBlock start="^\[source\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.b:asciidoctor_source_language

        " :source-language: python
        "```lang
        "for i in ...
        "```
        exe 'syn region asciidoctorSourceHighlightDefault'.b:asciidoctor_source_language.' matchgroup=asciidoctorBlock start="^```\s*$" end="^.*\n\?\zs```\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.b:asciidoctor_source_language
    endif

    "" Other languages
    for s:type in g:asciidoctor_fenced_languages + [get(b:, "asciidoctor_source_language", "NONE")]
        if s:type ==# "NONE"
            continue
        endif
        "[source,lang]
        " for i in ...
        "
        exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*$" end="^\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.s:type

        "[source,lang]
        "----
        "for i in ...
        "----
        exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.s:type

        "```lang
        "for i in ...
        "```
        exe 'syn region asciidoctorSourceHighlightDefault'.s:type.' matchgroup=asciidoctorBlock start="^```'.s:type.'\s*$" end="^.*\n\?\zs```\s*$" keepend contains=asciidoctorCallout,@asciidoctorSourceHighlight'.s:type


    endfor
    unlet! s:type
endif

" Contents of plantuml blocks should be highlighted with plantuml syntax...
" There is no built in plantuml syntax as far as I know.
" Tested with https://github.com/aklt/plantuml-syntax
syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\n\z(\.\.\.\.\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=@asciidoctorPlantumlHighlight
syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=@asciidoctorPlantumlHighlight

" Contents of literal blocks should not be highlighted
" TODO: make [literal] works with paragraph
syn region asciidoctorLiteralBlock matchgroup=asciidoctorBlock start="^\z(\.\.\.\.\+\)\s*$" end="^\z1\s*$" contains=@Spell,asciidoctorComment
syn region asciidoctorExampleBlock matchgroup=asciidoctorBlock start="^\z(====\+\)\s*$" end="^\z1\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment,asciidoctorIndented
syn region asciidoctorSidebarBlock matchgroup=asciidoctorBlock start="^\z(\*\*\*\*\+\)\s*$" end="^\z1\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment,asciidoctorIndented
syn region asciidoctorQuoteBlock   matchgroup=asciidoctorBlock start="^\z(____\+\)\s*$" end="^\z1\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment,asciidoctorIndented

syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="^\[\u\+\]\n\z(====\+\)\s*$" end="^\z1\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment,asciidoctorIndented

" Table blocks
syn match asciidoctorTableCell "\(^\|\s\)\@<=[.+*<^>aehlmdsv[:digit:]]\+|\||" contained containedin=asciidoctorTableBlock
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^|\z(===\+\)\s*$" end="^|\z1\s*$" keepend contains=asciidoctorTableCell,asciidoctorIndented,@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^,\z(===\+\)\s*$" end="^,\z1\s*$" keepend
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^;\z(===\+\)\s*$" end="^;\z1\s*$" keepend

syn match asciidoctorComment "^//.*$" contains=@Spell
syn region asciidoctorComment start="^////.*$" end="^////.*$" contains=@Spell

hi def link asciidoctorTitle                 Title
hi def link asciidoctorSetextHeader          Title
hi def link asciidoctorH1                    Title
hi def link asciidoctorH2                    Title
hi def link asciidoctorH3                    Title
hi def link asciidoctorH4                    Title
hi def link asciidoctorH5                    Title
hi def link asciidoctorH6                    Title
hi def link asciidoctorTitleDelimiter        Type
hi def link asciidoctorH1Delimiter           Type
hi def link asciidoctorH2Delimiter           Type
hi def link asciidoctorH3Delimiter           Type
hi def link asciidoctorH4Delimiter           Type
hi def link asciidoctorH5Delimiter           Type
hi def link asciidoctorH6Delimiter           Type
hi def link asciidoctorSetextHeaderDelimiter Type
hi def link asciidoctorListMarker            Delimiter
hi def link asciidoctorOrderedListMarker     asciidoctorListMarker
hi def link asciidoctorListContinuation      PreProc
hi def link asciidoctorComment               Comment
hi def link asciidoctorIndented              Comment
hi def link asciidoctorPlus                  PreProc
hi def link asciidoctorPageBreak             PreProc
hi def link asciidoctorCallout               Float
hi def link asciidoctorCalloutDesc           String

hi def link asciidoctorListingBlock          Comment
hi def link asciidoctorLiteralBlock          Comment

hi def link asciidoctorFile                  Underlined
hi def link asciidoctorUrl                   Underlined
hi def link asciidoctorEmail                 Underlined
hi def link asciidoctorUrlAuto               Underlined
hi def link asciidoctorEmailAuto             Underlined
hi def link asciidoctorUrlDescription        String

hi def link asciidoctorLink                  Underlined
hi def link asciidoctorAnchor                Underlined
hi def link asciidoctorAttribute             Identifier
hi def link asciidoctorCode                  Constant
hi def link asciidoctorOption                PreProc
hi def link asciidoctorBlock                 PreProc
hi def link asciidoctorBlockOptions          PreProc
hi def link asciidoctorTableSep              PreProc
hi def link asciidoctorTableCell             PreProc
hi def link asciidoctorTableEmbed            PreProc
hi def link asciidoctorInlineAnchor          PreProc
hi def link asciidoctorMacro                 Macro
hi def link asciidoctorIndexTerm             Macro

hi def asciidoctorBold                       gui=bold cterm=bold
hi def asciidoctorItalic                     gui=italic cterm=italic
hi def asciidoctorBoldItalic                 gui=bold,italic cterm=bold,italic

hi def link asciidoctorDefList               asciidoctorBold
hi def link asciidoctorCaption               Statement
hi def link asciidoctorAdmonition            asciidoctorBold

let b:current_syntax = "asciidoctor"
if main_syntax ==# 'asciidoctor'
    unlet main_syntax
endif
