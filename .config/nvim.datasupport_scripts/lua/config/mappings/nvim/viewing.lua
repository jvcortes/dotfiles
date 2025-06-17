local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

vim.keymap.set("n", "<leader><C-x>", function()
	local viewer = os.getenv("IMGVIEWER")
	local cword = vim.fn.expand("<cWORD>")
	local word = string.gsub(cword, "^[%[%]%s%(%)%{%}]*(.-)[%[%]%s%(%)%{%}]*$", "%1")
	local folder = vim.fn.expand("%:p:h")
	local path = ''
	local cmd = ''
	local checkcmd = ''

	if string.sub(word, 1, 1) == '/' then
		path = word
	else
		path = folder .. "/" .. word
	end

	if file_exists(path) then
		checkcmd = "identify " .. path .. " > /dev/null 2>&1"

		if os.execute(checkcmd) == 0 then
			cmd = viewer .. " " .. path
			print(cmd)
			vim.fn.jobstart(cmd)
		else
			print("Path doesn't correspond to an image.")
		end
	else
		print("Path is not valid or doesn't exist.")
	end
end)
