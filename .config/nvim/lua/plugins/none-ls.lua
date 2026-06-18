return {
	'nvimtools/none-ls.nvim',
	opts = {},
	config = function()
		local null_ls = require("null-ls")

		local desired_sources = {
			{ source = null_ls.builtins.completion.spell },
			{ source = null_ls.builtins.diagnostics.vale, command = "vale" },
			{ source = null_ls.builtins.diagnostics.eslint_d, command = "eslint_d" },
		}

		local sources = {}
		for _, entry in ipairs(desired_sources) do
			if entry.command == nil or vim.fn.executable(entry.command) == 1 then
				table.insert(sources, entry.source)
			end
		end

		null_ls.setup({ sources = sources })
	end
}
