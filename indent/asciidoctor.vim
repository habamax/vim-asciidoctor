if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" prevent incorrect indentation with ==
setlocal indentexpr=AsciidoctorIndent()
func! AsciidoctorIndent() abort
    return -1
endfunc
