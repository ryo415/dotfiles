------------------------------------------
--- GENERAL
------------------------------------------
vim.opt.encoding = "utf-8"	-- default encoding
vim.g.mapleader = " "       -- Leaderキーをスペースキーに設定
vim.g.maplocalleader = "\\"

-----------------------------------------
--- OVERRIDE
-----------------------------------------
require("options") 			-- base options
require("keymaps")			-- key mapping
require("config.lazy")  -- lazy.nvim
require("lsp")				  -- lsp
