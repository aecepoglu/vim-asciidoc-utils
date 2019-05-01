local TODOS = {
	none = {todo="", done="", val=""},
	bracket = function(val)
		return {todo="[ ] ", done="[x] ", val=val}
	end,
	text = function(val)
		return {todo="TODO ", done="DONE ", val=val}
	end
}

local toggle_todo = function(x)
	if x.val == x.todo then
		return x.done
	else
		return x.todo
	end
end

local function starts_with(str, pat)
	return #pat <= #str and str:sub(1, #pat) == pat
end

local function starts_with_any(str, pats)
	for _, pat in pairs(pats) do
		if starts_with(str, pat) then
			return true
		end
	end
	return false
end

local function parse_list_item(str)
	local whitespace, bullets, rest = string.match(str, "^(%s*)([-*.]+) (.*)")

	if bullets ~= nil then
		local todo

		if starts_with_any(rest, {"TODO ", "DONE "}) then
			todo = TODOS.text(rest:sub(1, 5))
			rest = rest:sub(6)
		elseif starts_with_any(rest, {"[x] ", "[*] ", "[ ] "}) then
			todo = TODOS.bracket(rest:sub(1, 4))
			rest = rest:sub(5)
		else
			todo = TODOS.none
		end

		return bullets, todo, whitespace, rest
	else
		return nil
	end
end

function add_list_item()
	local bullets, todo = parse_list_item(vim.api.nvim_get_current_line())

	if bullets ~= nil then
		return "\n" .. bullets .. " " .. todo.todo
	else
		return "\n"
	end
end

function toggle_list_item()
	local bullets, todo, whitespace, rest = parse_list_item(vim.api.nvim_get_current_line())
	if todo ~= TODOS.none then
		vim.api.nvim_set_current_line(whitespace .. bullets .. " " .. toggle_todo(todo) .. rest)
	end
end
