local BRACKET = "[.*x] "

local a = vim.api

local function get_line(buf_id, linenum)
	local lines = a.nvim_buf_get_lines(buf_id, linenum, linenum + 1, true)

	return #lines == 1 and lines[1]
end

function easy_folder()
	local buf_id = a.nvim_get_current_buf()
	local linenum = a.nvim_get_vvar("lnum") - 1
	local line = get_line(buf_id, linenum)
	local indent = line
		and string.match(line, "^[ \t]*" .. BRACKET)
		and string.find(line, BRACKET)

	if indent  then
		return ">" .. tostring(indent)
	else
		return "="
	end
end

function fold_namer()
	local buf_id = a.nvim_get_current_buf()
	local linenum, foldend = a.nvim_get_vvar("foldstart"), a.nvim_get_vvar("foldend")
	local line = get_line(buf_id, linenum - 1)
	local bracket_start, bracket_end = string.find(line, BRACKET)
	local indent = a.nvim_call_function("indent", {linenum})
	return string.rep(" ", indent)
		.. string.sub(line, bracket_start, bracket_end - 1) .. "›"
		.. string.sub(line, bracket_end)
		.. " (" .. (foldend - linenum) .. ")"
end

function toggle()
	local line = a.nvim_get_current_line()
	local i0, i1 = string.find(line, BRACKET)
	local c = i0 and string.sub(line, i0 + 1, i1 - 2)
	if not c then
		return
	else
		a.nvim_set_current_line(
			string.sub(line, 1, i0)
			.. (c == "o" and " " or "o")
			.. string.sub(line, i1 - 1)
			)
	end
end

local win = a.nvim_get_current_win()
a.nvim_win_set_option(win, "foldmethod", "expr")
a.nvim_win_set_option(win, "foldexpr", "luaeval(\"easy_folder()\")")
a.nvim_win_set_option(win, "foldtext", "luaeval(\"fold_namer()\")")
a.nvim_command("highlight Folded guibg=None guifg=Normal")
a.nvim_set_option("fillchars", "fold: ")
