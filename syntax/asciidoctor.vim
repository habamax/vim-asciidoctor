" Vim syntax file
" Language:     asciidoctor
" Maintainer:   Maxim Kim <habamax@gmail.com>
" Filenames:    *.adoc
" Last Change:  2018-11-01

if exists("b:current_syntax")
	finish
endif

if !exists('main_syntax')
	let main_syntax = 'asciidoctor'
endif

if !exists('g:asciidoctor_fenced_languages')
	let g:asciidoctor_fenced_languages = []
endif
for s:type in map(copy(g:asciidoctor_fenced_languages),'matchstr(v:val,"[^=]*$")')
	if s:type =~ '\.'
		let b:{matchstr(s:type,'[^.]*')}_subtype = matchstr(s:type,'\.\zs.*')
	endif
	exe 'syn include @asciidoctorHighlight'.substitute(s:type,'\.','','g').' syntax/'.matchstr(s:type,'[^.]*').'.vim'
	unlet! b:current_syntax
endfor
unlet! s:type

syn sync minlines=10
syn case ignore

" syn match asciidoctorValid '[<>]\c[a-z/$!]\@!'
" syn match asciidoctorValid '&\%(#\=\w*;\)\@!'

syn match asciidoctorOption "^:[[:alnum:]-]\{-}:.*$"

syn cluster asciidoctorBlock contains=asciidoctorTitle,asciidoctorH1,asciidoctorH2,asciidoctorH3,asciidoctorH4,asciidoctorH5,asciidoctorH6,asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock
syn cluster asciidoctorInline contains=asciidoctorLineBreak,asciidoctorLinkText,asciidoctorItalic,asciidoctorBold,asciidoctorCode,asciidoctorError,asciidoctorBoldItalic

syn match asciidoctorH1 "^[^[].\+\n=\+$" contains=@asciidoctorInline,asciidoctorHeadingRule,asciidoctorAutomaticLink
syn match asciidoctorH2 "^[^[].\+\n-\+$" contains=@asciidoctorInline,asciidoctorHeadingRule,asciidoctorAutomaticLink

syn match asciidoctorHeadingRule "^[=-]\+$" contained

syn match asciidoctorTitle "^=\s.*$"
syn match asciidoctorH1 "^==\s.*$"
syn match asciidoctorH2 "^===\s.*$"
syn match asciidoctorH3 "^====\s.*$"
syn match asciidoctorH4 "^=====\s.*$"
syn match asciidoctorH5 "^======\s.*$"
syn match asciidoctorH6 "^=======\s.*$"


syn match asciidoctorListMarker "^\s*\(-\|\*\+\|\.\+\)\%(\s\+\S\)\@="
syn match asciidoctorOrderedListMarker "^\s*\d\+\.\%(\s\+\S\)\@="

syn match asciidoctorDefList "^\S.\{-}::\_s"
syn match asciidoctorCaption "^\.\S.\+$"

" syn match asciidoctorUrl "\S\+" nextgroup=asciidoctorUrlTitle skipwhite contained
" syn region asciidoctorUrl matchgroup=asciidoctorUrlDelimiter start="<" end=">" oneline keepend nextgroup=asciidoctorUrlTitle skipwhite contained
" syn region asciidoctorUrlTitle matchgroup=asciidoctorUrlTitleDelimiter start=+"+ end=+"+ keepend contained
" syn region asciidoctorUrlTitle matchgroup=asciidoctorUrlTitleDelimiter start=+'+ end=+'+ keepend contained
" syn region asciidoctorUrlTitle matchgroup=asciidoctorUrlTitleDelimiter start=+(+ end=+)+ keepend contained

" syn region asciidoctorLinkText matchgroup=asciidoctorLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=asciidoctorLink,asciidoctorId skipwhite contains=@asciidoctorInline,asciidoctorLineStart
" syn region asciidoctorLink matchgroup=asciidoctorLinkDelimiter start="(" end=")" contains=asciidoctorUrl keepend contained
" syn region asciidoctorId matchgroup=asciidoctorIdDelimiter start="\[" end="\]" keepend contained
" syn region asciidoctorAutomaticLink matchgroup=asciidoctorUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline

syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\)\zs\*[^* ].\{-}\S\*\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\)\zs\*[^* ]\*\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorBold /\*\*\S.\{-}\*\*/
syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\)\zs_[^_ ].\{-}\S_\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\)\zs_[^_ ]_\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorItalic /__\S.\{-}__/
syn match asciidoctorBoldItalic /\%(^\|\s\)\zs\*_[^*_ ].\{-}\S_\*\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorBoldItalic /\%(^\|\s\)\zs\*_\S_\*\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorBoldItalic /\*\*_\S.\{-}_\*\*/
syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\)\zs`[^` ].\{-}\S`\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\)\zs`[^` ]`\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorCode /``.\{-}``/

syn match asciidoctorAdmonition /^\%(NOTE:\)\|\%(TIP:\)\|\%(IMPORTANT:\)\|\%(CAUTION:\)\|\%(WARNING:\)\s/

if main_syntax ==# 'asciidoctor'
	for s:type in g:asciidoctor_fenced_languages
		exe 'syn region asciidoctorHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\..*','','').' start="^\[source,\s*'.matchstr(s:type,'[^=]*').'\]\s*\n--\+\s*$" end="^[^[]*\n--\+\s*$" keepend contains=@asciidoctorHighlight'.substitute(matchstr(s:type,'[^=]*$'),'\.','','g')
	endfor
	unlet! s:type
endif

" syn match asciidoctorEscape "\\[][\\`*_{}()<>#+.!-]"
" syn match asciidoctorError "\w\@<=_\w\@="

syn match asciidoctorComment "^//.*$"


hi def link asciidoctorTitle                 Title
hi def link asciidoctorH1                    Title
hi def link asciidoctorH2                    Title
hi def link asciidoctorH3                    Title
hi def link asciidoctorH4                    Title
hi def link asciidoctorH5                    Title
hi def link asciidoctorH6                    Title
hi def link asciidoctorHeadingRule           Title
hi def link asciidoctorListMarker            Delimiter
hi def link asciidoctorOrderedListMarker     asciidoctorListMarker
hi def link asciidoctorBlockquote            Comment
hi def link asciidoctorComment               Comment

hi def link asciidoctorLinkText              htmlLink
" hi def link asciidoctorAutomaticLink         asciidoctorUrl
" hi def link asciidoctorUrl                   Float
" hi def link asciidoctorUrlTitle              String

hi asciidoctorBold                           gui=bold cterm=bold
hi asciidoctorItalic                         gui=italic cterm=italic
hi asciidoctorBoldItalic                     gui=bold,italic cterm=bold,italic
hi def link asciidoctorDefList               asciidoctorBold
hi def link asciidoctorCode                  PreProc
hi def link asciidoctorOption                PreProc
hi def link asciidoctorCaption               asciidoctorItalic
hi def link asciidoctorAdmonition            asciidoctorBold

" hi def link asciidoctorEscape                Special
" hi def link asciidoctorError                 Error

let b:current_syntax = "asciidoctor"
if main_syntax ==# 'asciidoctor'
	unlet main_syntax
endif
