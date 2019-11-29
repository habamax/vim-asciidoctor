" Vim syntax file
" Language:     asciidoctor
" Maintainer:   Maxim Kim <habamax@gmail.com>
" Filenames:    *.adoc
" vim: set noet

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

" Check :h syn-sync-fourth
syn sync minlines=100

syn case ignore

syn match asciidoctorOption "^:[[:alnum:]!-]\{-}:"
syn match asciidoctorListContinuation "^+\s*$"
syn match asciidoctorPageBreak "^<<<\+\s*$"

syn cluster asciidoctorBlock contains=asciidoctorTitle,asciidoctorH1,asciidoctorH2,asciidoctorH3,asciidoctorH4,asciidoctorH5,asciidoctorH6,asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInnerBlock contains=asciidoctorBlockquote,asciidoctorListMarker,asciidoctorOrderedListMarker,asciidoctorCodeBlock,asciidoctorDefList,asciidoctorAdmonition,asciidoctorAdmonitionBlock
syn cluster asciidoctorInline contains=asciidoctorItalic,asciidoctorBold,asciidoctorCode,asciidoctorBoldItalic,asciidoctorUrl,asciidoctorMacro,asciidoctorAttribute,asciidoctorInlineAnchor

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
syn sync match syncH1 grouphere NONE "^==\s.*$"
syn sync match syncH2 grouphere NONE "^===\s.*$"
syn sync match syncH3 grouphere NONE "^====\s.*$"
syn sync match syncH4 grouphere NONE "^=====\s.*$"
syn sync match syncH5 grouphere NONE "^======\s.*$"
syn sync match syncH6 grouphere NONE "^=======\s.*$"

syn match asciidoctorMacro "\a\+::\?\(\S[[:alnum:][:blank:]./\\:-]\{-}\)\?\[.\{-}\]" 
syn match asciidoctorAttribute "{[[:alpha:]][[:alnum:]-_:]\{-}}" 
syn region asciidoctorUrl matchgroup=asciidoctorMacro start="\%(link\|xref\|image\)::\?" end="\[.\{-}\]" oneline keepend skipwhite
syn match asciidoctorUrlDescription "\[.\{-}\]" contained containedin=asciidoctorUrl
syn match asciidoctorUrl "\%(http\|ftp\)s\?://\S\+\ze\%(\[.\{-}\]\)" nextgroup=asciidoctorUrlDescription
syn match asciidoctorUrl "<<.\{-}>>" 

if get(g:, 'asciidoctor_syntax_conceal', 0)
	syn region asciidoctorBold       matchgroup=Conceal start=/\m\*\*/ end=/\*\*/ contains=@Spell concealends oneline
	syn region asciidoctorBold       matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)\*\ze[^* ].\{-}\S/ end=/\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

	syn region asciidoctorItalic     matchgroup=Conceal start=/\m__/ end=/__/ contains=@Spell concealends oneline
	syn region asciidoctorItalic     matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)_\ze[^_ ].\{-}\S/ end=/_\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

	syn region asciidoctorBoldItalic matchgroup=Conceal start=/\m\*\*_/ end=/_\*\*/ contains=@Spell concealends oneline
	syn region asciidoctorBoldItalic matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)\*_\ze[^*_ ].\{-}\S/ end=/_\*\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline

	syn region asciidoctorCode       matchgroup=Conceal start=/\m``/ end=/``/ contains=@Spell concealends oneline
	syn region asciidoctorCode       matchgroup=Conceal start=/\m\%(^\|[[:punct:][:space:]]\@<=\)`\ze[^` ].\{-}\S/ end=/`\%([[:punct:][:space:]]\@=\|$\)/ contains=@Spell concealends oneline
else
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

syn match asciidoctorListMarker "^\s*\(-\|\*\+\|\.\+\)\%(\s\+\[[Xx ]\]\+\s*\)\?\%(\s\+\S\)\@="
syn match asciidoctorOrderedListMarker "^\s*\%(\d\+\|\a\)\.\%(\s\+\S\)\@="

syn match asciidoctorDefList ".\{-}::\_s\%(\_^\n\)\?" contains=@Spell

syn match asciidoctorAdmonition /\C^\%(NOTE:\)\|\%(TIP:\)\|\%(IMPORTANT:\)\|\%(CAUTION:\)\|\%(WARNING:\)\s/

syn match asciidoctorCaption "^\.[^.[:space:]].*$" contains=@asciidoctorInline,@Spell

syn match asciidoctorBlock "^\[.\{-}\]\s*$"

if get(g:, 'asciidoctor_syntax_indented', 1)
	syn match asciidoctorPlus      '^+\n\s' contained
	syn match asciidoctorIndented  '^+\?\n\%(\s\+\(-\|[*.]\+\|\d\+\.\|\a\.\)\s\)\@!\(\s.*\n\)\+' contains=asciidoctorPlus
endif

syn match asciidoctorInlineAnchor "\[\[.\{-}\]\]"

" Listing block
" --
" block that will not be
" highlighted
" --
syn region asciidoctorListingBlock matchgroup=asciidoctorBlock start="^\z(--\+\)\s*$" end="^\z1\s*$" contains=CONTAINED,asciidoctorUrlDescription,asciidoctorTableCell,@asciidoctorInline

" General [source] block
syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*$" end="^\s*$" keepend contains=CONTAINED,asciidoctorUrlDescription,asciidoctorTableCell,@asciidoctorInline
syn region asciidoctorSourceBlock matchgroup=asciidoctorBlock start="^\[source\%(,.*\)*\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=CONTAINED,asciidoctorUrlDescription,asciidoctorTableCell,@asciidoctorInline

" Source highlighting with programming languages
if main_syntax ==# 'asciidoctor'

	"" Default :source-language: is set up
	"" b:asciidoctor_source_language should be set up in ftplugin -- reading
	"" first 20(?) rows of a file
	" :source-language: python
	"[source]
	" for i in ...
	"
	if get(b:, "asciidoctor_source_language", "NONE") != "NONE"
		exe 'syn region asciidoctorSourceHighlightDefault'.b:asciidoctor_source_language.' matchgroup=asciidoctorBlock start="^\[source\]\s*$" end="^\s*$" keepend contains=@asciidoctorSourceHighlight'.b:asciidoctor_source_language
	endif

	" if :source-language: is set up
	" :source-language: python
	"[source]
	"----
	" for i in ...
	"----
	if get(b:, "asciidoctor_source_language", "NONE") != "NONE"
		exe 'syn region asciidoctorSourceHighlightDefault'.b:asciidoctor_source_language.' matchgroup=asciidoctorBlock start="^\[source\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=@asciidoctorSourceHighlight'.b:asciidoctor_source_language
	endif

	"" Other languages
	for s:type in g:asciidoctor_fenced_languages
		"[source,lang]
		" for i in ...
		"
		exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*$" end="^\s*$" keepend contains=@asciidoctorSourceHighlight'.s:type

		"[source,lang]
		"----
		"for i in ...
		"----
		exe 'syn region asciidoctorSourceHighlight'.s:type.' matchgroup=asciidoctorBlock start="^\[\%(source\)\?,\s*'.s:type.'\%(,.*\)*\]\s*\n\z(--\+\)\s*$" end="^.*\n\zs\z1\s*$" keepend contains=@asciidoctorSourceHighlight'.s:type


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
syn region asciidoctorLiteralBlock matchgroup=asciidoctorBlock start="^\z(\.\.\.\.\+\)\s*$" end="^\z1\s*$" contains=CONTAINED,@Spell,asciidoctorComment,asciidoctorUrlDescription,@asciidoctorInline

" Admonition blocks
" It would be way faster to just highlight block separators for some of them
syn match asciidoctorBlock "^====\+\s*$"
syn match asciidoctorBlock "^\*\*\*\*\+\s*$"
" syn region asciidoctorAdmonitionBlock matchgroup=asciidoctorBlock start="\C^\(\[NOTE]\|\[TIP]\|\[IMPORTANT]\|\[CAUTION]\|\[WARNING]\|\[example]\)\s*\%(\n\.\S.\{-}\)\?\n====\+\s*$" end="^.*\n\zs====\s*$" contains=@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment


" Table blocks
syn match asciidoctorTableCell "\(^\|\s\)\@<=[.+*<^>aehlmdsv[:digit:]]\+|\||" contained containedin=asciidoctorTableBlock
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^|===\+\s*$" end="^|===\+\s*$" keepend contains=asciidoctorTableCell,asciidoctorIndented,@asciidoctorInnerBlock,@asciidoctorInline,@Spell,asciidoctorComment
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^,===\+\s*$" end="^,===\+\s*$" keepend
syn region asciidoctorTableBlock matchgroup=asciidoctorBlock start="^;===\+\s*$" end="^;===\+\s*$" keepend

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
hi def link asciidoctorListContinuation      Delimiter
hi def link asciidoctorComment               Comment
hi def link asciidoctorIndented              Comment
hi def link asciidoctorPlus                  Delimiter
hi def link asciidoctorPageBreak             Delimiter

hi def link asciidoctorUrl                   Underlined
hi def link asciidoctorUrlDescription        Constant

" hi def link asciidoctorUrlTitle              String

hi def link asciidoctorMacro                 PreProc
hi def link asciidoctorAttribute             Identifier
hi def link asciidoctorCode                  Constant
hi def link asciidoctorOption                Identifier
hi def link asciidoctorBlock                 Delimiter
hi def link asciidoctorTableSep              Delimiter
hi def link asciidoctorTableCell             Delimiter
hi def link asciidoctorTableEmbed            Delimiter
hi def link asciidoctorInlineAnchor          Delimiter

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
