return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- only start session saving when an actual file was opened
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Load session for cwd",
		},
		{
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select session",
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Load last session",
		},
		{
			"<leader>qw",
			function()
				require("persistence").save()
			end,
			desc = "Save session",
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Stop session saving",
		},
		{
			"<leader>qr",
			function()
				require("persistence").start()
			end,
			desc = "Resume session saving",
		},
	},
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/",
		need = 1,
		branch = true,
	},
}
