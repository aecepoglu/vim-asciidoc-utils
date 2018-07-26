" Vim syntax file
" Language: t

if exists("b:current_syntax")
    finish
endif

syntax match _other '^.*$'
syntax match _custom '^\s*\[.\] .*$'
syntax match _todo '^\s*\[ \] .*$'
syntax match _done '^\s*\[[oOxX]\] .*$'
syntax match _warn '^\s*\[!\] .*$'

"highlight _todo guifg=Statement
"highlight _done guifg=2
"highlight _warn ctermfg=2
highlight def link _done Identifier
highlight def link _custom Ignore
highlight def link _warn Error
highlight def link _todo Type
highlight def link _other Comment

let b:current_syntax = "t"
