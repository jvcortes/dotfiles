return {
	"nvim-neorg/neorg",
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	config = function()
		local neorg = require("neorg")

		neorg.setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.keybinds"] = {
					config = {
						default_keybinds = true,
						neorg_leader = "\\"
					}
				},
				["core.integrations.nvim-cmp"] = {},
				["core.completion"] = {
					config = {engine = "nvim-cmp", name = "[n]"}
				},
				["core.dirman"] = {
					config = {
						workspaces = {
							notes = "~/notes",
						},
						default_workspace = 'notes'
					},
				},
				["core.integrations.telescope"] = {},
				["core.looking-glass"] = {}
			},
		})
	end,
	dependencies = { {"nvim-neorg/neorg-telescope"} }
}
