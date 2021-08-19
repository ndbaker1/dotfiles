" Plugins
call plug#begin()

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-rhubarb'

Plug 'cohama/lexima.vim'

Plug 'junegunn/fzf'

Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lspconfig'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'hoob3rt/lualine.nvim'

Plug 'ray-x/lsp_signature.nvim'

call plug#end()

" Turn on Default LuaLine
:lua require('lualine').setup()
" Turn on LSP Signature
:lua require("lsp_signature").setup()

" Vim Settings
"
set number

set title

set encoding=utf-8

set showcmd

set mouse=a

set textwidth=80

set whichwrap=bs<>[]

set ttyfast

set tabpagemax=50

