local blink = require("blink.cmp")
local servers = require("config.lsp.servers")
local lspconfig = require("lspconfig")
local fidget = require("fidget")
local mason = require("mason")

local capabilities = blink.get_lsp_capabilities({}, false)

fidget.setup({})
mason.setup()

for lang, config in pairs(servers) do
	-- Check for project-specific server override
	local server_name = vim.g.lsp_servers and vim.g.lsp_servers[lang] or config.use
	local server_config = nil

	-- Find the server config that matches the "use" server name
	for _, srv in pairs(config.servers) do
		if srv.name == server_name then
			server_config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
			}, srv.config)
			break
		end
	end

	if server_config then
		vim.lsp.config(server_name, server_config)
		vim.lsp.enable(server_name)
	end
end

vim.diagnostic.config({
	update_in_insert = true,
	signs = true,
	virtual_text = true,
	float = {
		focusable = false,
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "",
	},
})
