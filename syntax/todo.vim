" Vim syntax file
" Language: todo

if exists("b:current_syntax")
    finish
endif

syntax match _other     '^.*$'
syntax match _todo      '^\s*\. ' 
syntax match _done      '^\s*x ' 

highlight def link _todo      Normal
highlight def link _done      Normal
highlight def link _other     Comment

let b:current_syntax = "todo"
