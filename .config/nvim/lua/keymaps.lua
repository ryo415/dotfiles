-- ノーマルモードで <leader>+「|」キー → 画面縦分割（:vsplit）
vim.keymap.set("n", "<leader>|", ":vsplit<cr>", { silent = true, desc = "縦分割" })
-- ノーマルモードで <leader>+「-」キー → 画面横分割（:split）
vim.keymap.set("n", "<leader>-", ":split<cr>", { silent = true, desc = "横分割" })
-- 画面分割後の画面間移動設定
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "左ウィンドウへ" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "下ウィンドウへ" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "上ウィンドウへ" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "右ウィンドウへ" })

-- nvim-tree
vim.keymap.set("n", "<leader>nt", ":NvimTreeOpen<CR>", { silent = true, desc = "NvimTreeOpen" })
-- Diffview
vim.keymap.set("n", "<leader>df", ":DiffviewOpen<CR>", { silent = true, desc = "DiffviewOpen" })
