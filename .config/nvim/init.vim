"__ Vim Settings __
set ttyfast
set mouse=a
set encoding=utf-8
set hidden
set incsearch
set tabpagemax=50
" History
set noswapfile
set nobackup
set undofile
set undodir=$HOME/.config/nvim/undodir
" Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
" Startup 
set exrc
" Visuals
set guicursor=
set number
set relativenumber
set title
set showcmd
set textwidth=80
set whichwrap=bs<>[]
set scrolloff=8
set signcolumn=yes

" __ Plugins __
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

