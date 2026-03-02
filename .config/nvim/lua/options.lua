vim.opt.expandtab = true                -- Tab入力をスペースに変換（タブ文字を使わない）
vim.opt.shiftwidth = 2                  -- 自動インデントや >> << の移動幅を2スペースに設定
vim.opt.tabstop = 2                     -- Tab文字の表示幅を2スペースに設定
vim.opt.softtabstop = 2                 -- Tabキー押下時の実際の挿入スペース数（expandtab時）を2に設定
vim.opt.number = true                   -- 行番号を左端に表示
vim.opt.ignorecase = true               -- 検索時、大文字小文字を区別しない
vim.opt.smartcase = true                -- 検索時、大文字がある場合ignorecaseを上書きする(大文字を検索する際は大文字区別する)
vim.opt.showmode = false                -- 現在のモードを表示しない(表示はlualineに任せる)

vim.opt.clipboard:append('unnamedplus') -- Neovimのシステムクリップボードを有効化

vim.cmd("filetype plugin indent on")    -- ファイルタイプ検出、プラグイン、インデントを有効化

