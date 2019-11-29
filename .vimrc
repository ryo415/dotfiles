" 自動インデント有効
set autoindent

" 行番号を表示
set nu

" タブを半角2字
set tabstop=2

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/ryohei.kikuchi/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/Users/ryohei.kikuchi/.cache/dein')
  call dein#begin('/Users/ryohei.kikuchi/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/Users/ryohei.kikuchi/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------
