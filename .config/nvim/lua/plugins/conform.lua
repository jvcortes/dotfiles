return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>bf",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "(conform) Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,

	config = function()
		local conform = require('conform')

		-- Global defaults; override per project in .nvim.lua.
		-- These are looked up at format time, not only once at startup,
		-- so project-local .nvim.lua values work reliably.
		-- Example project-level override:
		--   -- .nvim.lua
		--   vim.g.conform_python_formatters = { "ruff_fix", "ruff_format" }
		--   vim.g.conform_lua_formatters = { "stylua" }
		--   vim.g.conform_markdown_formatters = { "prettierd" }
		--   vim.g.conform_typescript_formatters = { "biome" }
		--
		--   -- Or disable formatting for a filetype in this project:
		--   vim.g.conform_python_formatters = {}
		--
		-- You can also switch Python projects to isort+ruff when needed:
		--   vim.g.conform_python_formatters = { "isort", "ruff_fix", "ruff_format" }
		local function project_or_default(global_name, default)
			return function()
				local value = vim.g[global_name]
				if value ~= nil then
					return value
				end
				return default
			end
		end

		local formatters_by_ft = {
			lua = project_or_default("conform_lua_formatters", { "stylua" }),
			python = project_or_default("conform_python_formatters", { "isort", "ruff_fix", "ruff_format" }),
			markdown = project_or_default("conform_markdown_formatters", { "prettierd", stop_after_first = true }),
			javascript = project_or_default("conform_javascript_formatters", { "prettierd", stop_after_first = true }),
			typescript = project_or_default("conform_typescript_formatters", { "prettierd", stop_after_first = true }),
			javascriptreact = project_or_default("conform_javascriptreact_formatters", { "prettierd", stop_after_first = true }),
			typescriptreact = project_or_default("conform_typescriptreact_formatters", { "prettierd", stop_after_first = true }),
		}

		conform.setup({
			formatters_by_ft = formatters_by_ft,
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500 },
		})
	end
}
