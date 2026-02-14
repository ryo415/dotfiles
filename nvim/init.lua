-- lazy.nvim
require("config.lazy")

------------------------------------------
--- GENERAL
------------------------------------------
vim.opt.number = true		-- Show line numbers
vim.opt.encoding = "utf-8"	-- default encoding
vim.opt.tabstop = 4			-- Number of spaces a tab counts for
vim.opt.shiftwidth = 4		-- Number of spaces for auto-indent
vim.opt.ignorecase = true	-- Ignore case in search patterns
vim.opt.smartcase = true	-- Override ignorecase if search pattern contains uppercase
vim.opt.showmode = false	-- Show current mode

-----------------------------------------
--- OVERRIDE
-----------------------------------------
require("options") 			-- base options
require("keymaps")			-- key mapping
require("lsp")				-- lsp
