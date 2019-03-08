" Vim syntax file
" Language: todo

if exists("b:current_syntax")
    finish
endif

syntax match _bracket "\." contained conceal cchar=·
syntax match _bracket "x" contained conceal cchar=✓
syntax match _other     '^.*$'
syntax match _todo      '^\s*\. ' contains=_bracket
syntax match _done      '^\s*x ' contains=_bracket

highlight def link _todo      Normal
highlight def link _done      Normal
highlight def link _other     Comment
highlight def link _bracket   Normal

let b:current_syntax = "todo"
