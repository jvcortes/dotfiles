local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

math.randomseed(os.time())

local function pick_color()
	local colors = { "String", "Identifier", "Keyword", "Number" }
	return colors[math.random(#colors)]
end

local function footer()
	local version = vim.version()
	local nvim_version_info = "  Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch

	return nvim_version_info
end

local logo = {
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "         //                 /*          ",
        "      ,(/(//,               *###        ",
        "    ((((((////.             /####%*     ",
        " ,/(((((((/////*            /########   ",
        "/*///((((((//////.          *#########/ ",
        "//////((((((((((((/         *#########/.",
        "////////((((((((((((*       *#########/.",
        "/////////(/(((((((((((      *#########(.",
        "//////////.,((((((((((/(    *#########(.",
        "//////////.  /(((((((((((,  *#########(.",
        "(////////(.    (((((((((((( *#########(.",
        "(////////(.     ,#((((((((((##########(.",
        "((//////((.       /#((((((((##%%######(.",
        "((((((((((.         #(((((((####%%##%#(.",
        "((((((((((.          ,((((((#####%%%%%(.",
        " .#(((((((.            (((((#######%%   ",
        "    /(((((.             .(((#%##%%/*    ",
        "      ,(((.               /(#%%#        ",
        "        ./.                 #*          ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
        "                                        ",
}

dashboard.section.header.val = logo
dashboard.section.header.opts.hl = pick_color()

dashboard.section.buttons.val = {
	dashboard.button("-", "  File explorer"),
	dashboard.button("SPC f r", "  Recent files"),
	dashboard.button("SPC f f", "  Find files"),
	dashboard.button("SPC f g", "  Find string"),
	dashboard.button("SPC l l", "  Plugins"),
}

dashboard.section.footer.val = footer()
dashboard.section.footer.opts.hl = "Constant"

alpha.setup(dashboard.opts)

vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
