local a = vim.api

local Bullet = {
	todo= 0,
	done= 1,
	important= 2,
}

local char_to_bullet = {
	['.']= Bullet.todo,
	['x']= Bullet.done,
	['*']= Bullet.important,
}

local bullet_to_char = {
	[Bullet.todo] = ".",
	[Bullet.done] = "x",
	[Bullet.important] = "*",
}

-- string -> Bullet
local bullet_of_char = function(c)
	return char_to_bullet[c] or Bullet.todo
end

local toggle_bullet = function(x)
	return x == Bullet.done and Bullet.todo or Bullet.done
end

local string_of_bullet = function(x)
	return bullet_to_char[x] or "?"
end

-- string -> (int, Bullet)
local function find_bullet(line)
	local i = string.find(line, "[.x*] ")
	if i then
		return i, bullet_of_char(line:sub(i, i))
	else
		return nil, nil
	end
end

-- () -> BufferInfo
local function get_buf()
	local buf_id = a.nvim_get_current_buf()
	return {
		buf_id = buf_id,
		tabwidth = a.nvim_buf_get_option(buf_id, "tabstop"),
	}
end

local function get_line(buf_id, linenum)
	local lines = a.nvim_buf_get_lines(buf_id, linenum, linenum + 1, true)

	return #lines == 1 and lines[1]
end

function folder()
	local buf = get_buf()
	local linenum = a.nvim_get_vvar("lnum") - 1
	local line = get_line(buf.id, linenum)
	local indent = find_bullet(line)

	if indent then
		return ">" .. tostring(indent)
	else
		return "="
	end
end

function namer()
	local buf = get_buf()
	local linenum, foldend = a.nvim_get_vvar("foldstart"), a.nvim_get_vvar("foldend")
	local line = get_line(buf.id, linenum - 1)
	local indent, bullet = find_bullet(line)

	local total, done = 0, 0
	for i=linenum + 1, foldend do
		local _, x = find_bullet(get_line(buf.id, i - 1))
		if x then
			total = total + 1
			if x == Bullet.done then
				done = done + 1
			end
		end
	end


	return string.rep(" ", (indent - 1) * buf.tabwidth)
		.. (string_of_bullet(bullet)) .. "›"
		.. string.sub(line, indent + 1)
		.. " (" .. done .. "/" .. total .. ")"
end

function toggle()
	local line = a.nvim_get_current_line()
	local i, bullet = find_bullet(line)

	return i and a.nvim_set_current_line(
			string.sub(line, 1, i - 1)
			.. (string_of_bullet(toggle_bullet(bullet)))
			.. string.sub(line, i + 1)
		)
end

local win = a.nvim_get_current_win()
a.nvim_win_set_option(win, "foldmethod", "expr")
a.nvim_win_set_option(win, "foldexpr", "luaeval(\"folder()\")")
a.nvim_win_set_option(win, "foldtext", "luaeval(\"namer()\")")
a.nvim_command("highlight Folded guibg=None guifg=Normal")
a.nvim_command("highlight Folded guibg=None guifg=Normal")
a.nvim_set_option("fillchars", "fold: ")
