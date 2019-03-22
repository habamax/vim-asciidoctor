" Vim syntax file
" Language:     asciidoctor
" Maintainer:   Maxim Kim <habamax@gmail.com>
" Filenames:    *.adoc
" Last Change:  2018-11-01

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
for s:type in g:asciidoctor_fenced_languages
	exe 'syn include @asciidoctorSourceHighlight'.s:type.' syntax/'.s:type.'.vim'
	unlet! b:current_syntax
endfor
unlet! s:type

if globpath(&rtp, "syntax/plantuml.vim") != ''
	syn include @asciidoctorPlantumlHighlight syntax/plantuml.vim
	unlet! b:current_syntax
endif

" also check :h syn-sync-fourth
syn sync minlines=50

syn case ignore

" syn match asciidoctorValid '[<>]\c[a-z/$!]\@!'
" syn match asciidoctorValid '&\%(#\=\w*;\)\@!'

syn match asciidoctorOption "^:[[:alnum:]!-]\{-}:.*$"

syn cluster asciidoctorBlock contains=asciidoctorTitle,asciidoctorH1,asciidoctorH2,asciidoctorH3,asciidoctorH4,asciidoctorH5,asciidoctorH6,asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock
syn cluster asciidoctorInnerBlock contains=asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock
syn cluster asciidoctorInline contains=asciidoctorItalic,asciidoctorBold,asciidoctorCode,asciidoctorBoldItalic,asciidoctorUrl,asciidoctorMacro

" really hard to use them together with all the rest 'blocks'
" syn match asciidoctorH1 "^[^[].\+\n=\+$" contains=@asciidoctorInline,asciidoctorHeadingRule,asciidoctorAutomaticLink
" syn match asciidoctorH2 "^[^[].\+\n-\+$" contains=@asciidoctorInline,asciidoctorHeadingRule,asciidoctorAutomaticLink
" syn match asciidoctorHeadingRule "^[=-]\+$" contained

syn match asciidoctorTitle "^=\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH1 "^==\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH2 "^===\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH3 "^====\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH4 "^=====\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH5 "^======\s.*$" contains=@asciidoctorInline,@Spell
syn match asciidoctorH6 "^=======\s.*$" contains=@asciidoctorInline,@Spell


syn match asciidoctorListMarker "^\s*\(-\|\*\+\|\.\+\)\%(\s\+\S\)\@="
syn match asciidoctorOrderedListMarker "^\s*\d\+\.\%(\s\+\S\)\@="

" "TODO: wrong highlighting <2018-30-20 19:30>
" a| IF1. Customer Create/Update::
" v| IF1. Customer Create/Update::
" v| IF1. Customer Create/Update::
" .^l| IF1. Customer Create/Update::
" .3+^.>s|This cell spans 3 rows
syn match asciidoctorDefList "\(^[^|[:space:]]\).\{-}::\_s" contains=@Spell

syn match asciidoctorMacro "\a\+::\?\w\S\{-}\[.\{-}\]" 
syn region asciidoctorUrl matchgroup=asciidoctorMacro start="\%(image\|link\)::\?" end="\[.\{-}\]" oneline keepend skipwhite
syn match asciidoctorUrl "\%(http\|ftp\)s\?://\S\+" 

syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\)\zs\*[^* ].\{-}\S\*\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorBold /\%(^\|[[:punct:][:space:]]\)\zs\*[^* ]\*\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorBold /\*\*\S.\{-}\*\*/ contains=@Spell
syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\)\zs_[^_ ].\{-}\S_\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorItalic /\%(^\|[[:punct:][:space:]]\)\zs_[^_ ]_\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorItalic /__\S.\{-}__/ contains=@Spell
syn match asciidoctorBoldItalic /\%(^\|\s\)\zs\*_[^*_ ].\{-}\S_\*\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorBoldItalic /\%(^\|\s\)\zs\*_\S_\*\ze\%([[:punct:][:space:]]\|$\)/ contains=@Spell
syn match asciidoctorBoldItalic /\*\*_\S.\{-}_\*\*/ contains=@Spell
syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\)\zs`[^` ].\{-}\S`\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorCode /\%(^\|[[:punct:][:space:]]\)\zs`[^` ]`\ze\%([[:punct:][:space:]]\|$\)/
syn match asciidoctorCode /``.\{-}``/

syn match asciidoctorAdmonition /\C^\%(NOTE:\)\|\%(TIP:\)\|\%(IMPORTANT:\)\|\%(CAUTION:\)\|\%(WARNING:\)\s/

syn match asciidoctorCaption "^\.\S.\+$" contains=@asciidoctorInline

" Listing block TODO: doesn't work as expected, causes #2
" ----
" block that will not be
" highlighted
" ----
" syn region asciidoctorListingBlock start="\%(\%(^\[.\+\]\s*\)\|\%(^\s*\)\)\n---\+\s*$" end="^[^[]*\n---\+\s*$" contains=CONTAINED
" syn region asciidoctorListingBlock matchgroup=asciidoctorBlock start="^----\+\s*$" end="^----\+\s*$" contains=CONTAINED

" General [source] block
 syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*$" end="^\s*$" keepend contains=CONTAINED
 syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*\n---\+\s*$" end="^.*\n\zs---\+\s*$" keepend contains=CONTAINED

" Source highlighting with programming languages
if main_syntax ==# 'asciidoctor'
	for s:type in g:asciidoctor_fenced_languages
		"[source,lang]
		" for i in ...
		"
		exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*$" end="^\s*$" keepend contains=@asciidoctorSourceHighlight'.s:type

		"[source,lang]
		"----
		"for i in ...
		"----
		exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*\n----\+\s*$" end="^.*\n\zs----\+\s*$" keepend contains=@asciidoctorSourceHighlight'.s:type

	endfor
	unlet! s:type
endif

" Contents of plantuml blocks should be highlighted with plantuml syntax...
" There is no built in plantuml syntax as far as I know.
" Tested with https://github.com/aklt/plantuml-syntax
syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\n\.\.\.\.\+\s*$" end="^.*\n\zs\.\.\.\.\+\s*$" keepend contains=@asciidoctorPlantumlHighlight
syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\n--\+\s*$" end="^.*\n\zs--\+\s*$" keepend contains=@asciidoctorPlantumlHighlight

" Contents of literal blocks should not be highlighted
syn region asciidoctorLiteralBlock matchgroup=asciidoctorBlock start="^\[literal\]\s*\n\.\.\.\.\+\s*$" end="^.*\n\zs\.\.\.\.\+\s*$" keepend contains=CONTAINED,@Spell

" Admonition blocks
syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\[NOTE\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\[TIP\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\[IMPORTANT\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\[CAUTION\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\[WARNING\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

" Example block
syn region asciidoctorExampleBlock matchgroup=asciidoctorBlock start="\C^\[example\]\s*\n====\+\s*$" end="^.*\n\zs====\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

" More blocks
syn region asciidoctorQuoteBlock matchgroup=asciidoctorBlock start="\C^\[quote\%(,.\{-}\)\]\s*\n____\+\s*$" end="^.*\n\zs____\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

" Sidebar block
syn region asciidoctorQuoteBlock matchgroup=asciidoctorBlock start="^\*\*\*\*\+\s*$" end="^.*\n\zs\*\*\*\*\+\s*$" keepend contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell

" syn match asciidoctorEscape "\\[][\\`*_{}()<>#+.!-]"
" syn match asciidoctorError "\w\@<=_\w\@="

syn match asciidoctorComment "^//.*$" contains=@Spell


hi def link asciidoctorTitle                 Title
hi def link asciidoctorH1                    Title
hi def link asciidoctorH2                    Title
hi def link asciidoctorH3                    Title
hi def link asciidoctorH4                    Title
hi def link asciidoctorH5                    Title
hi def link asciidoctorH6                    Title
hi def link asciidoctorListMarker            Delimiter
hi def link asciidoctorOrderedListMarker     asciidoctorListMarker
hi def link asciidoctorComment               Comment

hi def link asciidoctorUrl                   Underlined
" hi def link asciidoctorUrlTitle              String

hi def link asciidoctorMacro                 Constant
hi def link asciidoctorCode                  Constant
hi def link asciidoctorOption                Comment
hi def link asciidoctorBlock                 Delimiter

hi asciidoctorBold                           gui=bold cterm=bold
hi asciidoctorItalic                         gui=italic cterm=italic
hi asciidoctorBoldItalic                     gui=bold,italic cterm=bold,italic
augroup asciidoctor_highlight_create
	au!
	autocmd ColorScheme * :hi asciidoctorBold gui=bold cterm=bold
	autocmd ColorScheme * :hi asciidoctorItalic gui=italic cterm=italic
	autocmd ColorScheme * :hi asciidoctorBoldItalic gui=bold,italic cterm=bold,italic
augroup end
hi def link asciidoctorDefList               asciidoctorBold
hi def link asciidoctorCaption               asciidoctorItalic
hi def link asciidoctorAdmonition            asciidoctorBold

" hi def link asciidoctorEscape                Special
" hi def link asciidoctorError                 Error

let b:current_syntax = "asciidoctor"
if main_syntax ==# 'asciidoctor'
	unlet main_syntax
endif
