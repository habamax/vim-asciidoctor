" Vim syntax file
" Language:     asciidoctor
" Maintainer:   Maxim Kim <habamax@gmail.com>
" Filenames:    *.adoc

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
" syn-syc-fourth will not help here I guess.
" the issue is that start and end of the blocks have the same delimiters
" and it looks like impossible to setup correct 'syn sync match'
" but let's try to do it...
" 1. redefin headings as regions instead of matches and sync them
syn sync minlines=100
" syn sync fromstart

syn case ignore

" syn match asciidoctorValid '[<>]\c[a-z/$!]\@!'
" syn match asciidoctorValid '&\%(#\=\w*;\)\@!'

syn match asciidoctorOption "^:[[:alnum:]!-]\{-}:"

syn cluster asciidoctorBlock contains=asciidoctorTitle,asciidoctorH1,asciidoctorH2,asciidoctorH3,asciidoctorH4,asciidoctorH5,asciidoctorH6,asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInnerBlock contains=asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorDefList,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInline contains=asciidoctorItalic,asciidoctorBold,asciidoctorCode,asciidoctorBoldItalic,asciidoctorUrl,asciidoctorMacro,asciidoctorAttribute

" really hard to use them together with all the rest 'blocks'
" syn match asciidoctorMarkdownH1 "^\s*[[:alpha:]].\+\n=\+$" contains=@asciidoctorInline
" syn match asciidoctorMarkdownH2 "^\s*[[:alpha:]].\+\n-\+$" contains=@asciidoctorInline

syn match asciidoctorTitle "^=\s.*$" contains=@asciidoctorInline,@Spell
syn region asciidoctorH1 start="^==\s" end="$" oneline contains=@asciidoctorInline,@Spell
syn region asciidoctorH2 start="^===\s" end="$" oneline contains=@asciidoctorInline,@Spell
syn region asciidoctorH3 start="^====\s" end="$" oneline contains=@asciidoctorInline,@Spell
syn region asciidoctorH4 start="^=====\s" end="$" oneline contains=@asciidoctorInline,@Spell
syn region asciidoctorH5 start="^======\s" end="$" oneline contains=@asciidoctorInline,@Spell
syn region asciidoctorH6 start="^=======\s" end="$" oneline contains=@asciidoctorInline,@Spell

syn sync clear
syn sync match syncH1 grouphere asciidoctorH1 "^==\s"
syn sync match syncH2 grouphere asciidoctorH2 "^===\s"
syn sync match syncH3 grouphere asciidoctorH3 "^====\s"
syn sync match syncH4 grouphere asciidoctorH4 "^=====\s"
syn sync match syncH5 grouphere asciidoctorH5 "^======\s"
syn sync match syncH6 grouphere asciidoctorH5 "^=======\s"

syn match asciidoctorListMarker "^\s*\(-\|\*\+\|\.\+\)\%(\s\+\[[Xx ]\]\+\s*\)\?\%(\s\+\S\)\@="
syn match asciidoctorOrderedListMarker "^\s*\d\+\.\%(\s\+\S\)\@="

" "TODO: wrong highlighting <2018-30-20 19:30>
" a| IF1. Customer Create/Update::
" v| IF1. Customer Create/Update::
" v| IF1. Customer Create/Update::
" .^l| IF1. Customer Create/Update::
" .3+^.>s|This cell spans 3 rows
syn match asciidoctorDefList "\(^[^|[:space:]]\).\{-}::\_s" contains=@Spell

syn match asciidoctorMacro "\a\+::\?\(\w\S\{-}\)\?\[.\{-}\]" 
syn match asciidoctorAttribute "{[[:alpha:]][[:alnum:]-_:]\{-}}" 
syn region asciidoctorUrl matchgroup=asciidoctorMacro start="\%(image\|link\)::\?" end="\[.\{-}\]" oneline keepend skipwhite
syn match asciidoctorUrl "\%(http\|ftp\)s\?://\S\+" 
syn match asciidoctorUrl "<<.\{-}>>" 

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

syn match asciidoctorAdmonition /\C^\%(NOTE:\)\|\%(TIP:\)\|\%(IMPORTANT:\)\|\%(CAUTION:\)\|\%(WARNING:\)\s/

syn match asciidoctorCaption "^\.[^.[:space:]].*$" contains=@asciidoctorInline,@Spell

syn match asciidoctorBlock "^\[.\{-}\]\s*$"

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
" syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\%(\n\.\S.\{-}\)\?\n\.\.\.\.\+\s*$" end="^.*\n\zs\.\.\.\.\+\s*$" contains=@asciidoctorPlantumlHighlight
syn region asciidoctorPlantumlBlock matchgroup=asciidoctorBlock start="^\[plantuml.\{-}\]\s*\n--\+\s*$" end="^.*\n\zs--\+\s*$" keepend contains=@asciidoctorPlantumlHighlight

" Contents of literal blocks should not be highlighted
syn region asciidoctorLiteralBlock matchgroup=asciidoctorBlock start="^\[literal\]\s*\n\.\.\.\.\+\s*$" end="^.*\n\zs\.\.\.\.\+\s*$" keepend contains=CONTAINED,@Spell,asciidoctorComment

" Admonition blocks
" It would be way faster to just highlight block separators for some of them
syn match asciidoctorBlock "^====\+\s*$"
syn match asciidoctorBlock "^\*\*\*\*\+\s*$"
" syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\(\[NOTE]\|\[TIP]\|\[IMPORTANT]\|\[CAUTION]\|\[WARNING]\|\[example]\)\s*\%(\n\.\S.\{-}\)\?\n====\+\s*$" end="^.*\n\zs====\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment

" Table blocks
" Table blocks could be really long and this trick vim syntax hl
" Trying to use simple matches instead -- it is dumber but anyway we don't
" need anything really smart here
" syn match asciidoctorTableCell "^[.+*<^>aehlmdsv[:digit:]]*|"
" syn match asciidoctorTableSep "^[,;:|]====*"

"" Block version
syn match asciidoctorTableCell "\(^\|\s\)\@<=[.+*<^>aehlmdsv[:digit:]]\+|\||" contained
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^|===\s*$" end="^|===\s*$" keepend contains=asciidoctorTableCell,@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^,===\s*$" end="^,===\s*$" keepend contains=@asciidoctorInline,@Spell,asciidoctorComment
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^;===\s*$" end="^;===\s*$" keepend contains=@asciidoctorInline,@Spell,asciidoctorComment

syn match asciidoctorComment "^//.*$" contains=@Spell

hi def link asciidoctorTitle                 Title
hi def link asciidoctorH1                    Title
" hi def link asciidoctorMarkdownH1            Title
hi def link asciidoctorH2                    Title
" hi def link asciidoctorMarkdownH2            Title
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
hi def link asciidoctorAttribute             Constant
hi def link asciidoctorCode                  Constant
hi def link asciidoctorOption                Define
hi def link asciidoctorBlock                 Delimiter
hi def link asciidoctorTableSep              Delimiter
hi def link asciidoctorTableCell             Delimiter

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
hi def link asciidoctorCaption               Statement
hi def link asciidoctorAdmonition            asciidoctorBold

" hi def link asciidoctorEscape                Special
" hi def link asciidoctorError                 Error

let b:current_syntax = "asciidoctor"
if main_syntax ==# 'asciidoctor'
	unlet main_syntax
endif
