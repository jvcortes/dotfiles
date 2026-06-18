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
		-- Example project-level override:
		--   -- .nvim.lua
		--   vim.g.conform_python_formatters = { "ruff_fix", "ruff_format" }
		--   vim.g.conform_lua_formatters = { "stylua" }
		--   vim.g.conform_markdown_formatters = { "prettierd" }
		--
		--   -- Or disable formatting for a filetype in this project:
		--   vim.g.conform_python_formatters = {}
		--
		-- You can also switch Python projects to isort+ruff when needed:
		--   vim.g.conform_python_formatters = { "isort", "ruff_fix", "ruff_format" }
		local formatters_by_ft = {
			lua = vim.g.conform_lua_formatters or { "stylua" },
			python = vim.g.conform_python_formatters or { "isort", "ruff_fix", "ruff_format" },
			markdown = vim.g.conform_markdown_formatters or { "prettierd", stop_after_first = true },
			javascript = vim.g.conform_javascript_formatters or { "prettierd", stop_after_first = true },
			typescript = vim.g.conform_typescript_formatters or { "prettierd", stop_after_first = true },
			javascriptreact = vim.g.conform_javascriptreact_formatters or { "prettierd", stop_after_first = true },
			typescriptreact = vim.g.conform_typescriptreact_formatters or { "prettierd", stop_after_first = true },
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
