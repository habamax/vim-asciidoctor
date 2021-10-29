if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

let s:undo_opts = "setl inde<"

if exists('b:undo_indent')
    let b:undo_indent .= "|" . s:undo_opts
else
    let b:undo_indent = s:undo_opts
endif

" prevent incorrect indentation with ==
setlocal indentexpr=-1
