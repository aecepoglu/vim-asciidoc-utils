lua require("todo")

function Adoc_addListItem()
	return luaeval("add_list_item()")
endfunction

nnoremap <return> :lua toggle_list_item()<CR>
inoremap <buffer><expr> <return> Adoc_addListItem()
