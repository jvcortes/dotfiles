local telescope = require('telescope.builtin')

local M = {}


function M.org_notes()
	telescope.find_files {
		cwd = '~/notes/',
		prompt_title = "Notes",
		layout_config = {
			height = 0.85
		},
		search_file = '**/*.[org|norg]'
	}
end


return M
