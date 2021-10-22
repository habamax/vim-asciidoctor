if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" prevent incorrect indentation with ==
setlocal indentexpr=-1
