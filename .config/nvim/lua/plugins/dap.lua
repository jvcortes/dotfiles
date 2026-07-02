return {
	'mfussenegger/nvim-dap',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',
		'mfussenegger/nvim-dap-python',
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")

		require("dapui").setup({})
		require("nvim-dap-virtual-text").setup({
			commented = true, -- Show virtual text alongside comment
		})

		dap_python.setup("python")

		vim.fn.sign_define("DapBreakpoint", {
			text = "",
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapBreakpointRejected", {
			text = "", -- or "❌"
			texthl = "DiagnosticSignError",
			linehl = "",
			numhl = "",
		})

		vim.fn.sign_define("DapStopped", {
			text = "", -- or "→"
			texthl = "DiagnosticSignWarn",
			linehl = "Visual",
			numhl = "DiagnosticSignWarn",
		})

		-- Automatically open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end

		local opts = { noremap = true, silent = true }

		-- Toggle breakpoint
		vim.keymap.set("n", "<leader>dt", function()
			dap.toggle_breakpoint()
		end, vim.tbl_extend('keep', opts, { desc = 'Toggle breakpoint' }))

		-- Continue / Start
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, vim.tbl_extend('keep', opts, { desc = 'Continue / Start' }))

		-- Step Over
		vim.keymap.set("n", "<leader>do", function()
			dap.step_over()
		end, vim.tbl_extend('keep', opts, { desc = 'Step over' }))

		-- Step Into
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, vim.tbl_extend('keep', opts, { desc = 'Step into' }))

		-- Step Out
		vim.keymap.set("n", "<leader>dO", function()
			dap.step_out()
		end, vim.tbl_extend('keep', opts, { desc = 'Step out' }))

		-- Keymap to terminate debugging
		vim.keymap.set("n", "<leader>dq", function()
			require("dap").terminate()
		end, vim.tbl_extend('keep', opts, { desc = 'Terminate' }))

		-- Toggle DAP UI
		vim.keymap.set("n", "<leader>du", function()
			dapui.toggle()
		end, vim.tbl_extend('keep', opts, { desc = 'Toggle DAP UI' }))
	end
}
