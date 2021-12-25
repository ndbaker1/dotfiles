"__ Vim Settings __
set ttyfast
set mouse=a
set encoding=utf-8
set hidden
set incsearch
set tabpagemax=50
set shm+=I

" HISTORY
set noswapfile
set nobackup
set undofile
set undodir=$HOME/.config/nvim/undodir

" SPACING
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set smartindent
" CURSORLINES
set cursorline
set clipboard+=unnamedplus
" STYLING FOR CURSORLINE
highlight CursorLine ctermbg=Black cterm=NONE
highlight CursorLineNr ctermbg=Black cterm=bold ctermfg=Green

" STARTUP 
set exrc

" EDITING
set number relativenumber
set title
set showcmd
set nohlsearch
set textwidth=80
set whichwrap=bs<>[]
set scrolloff=8
"set signcolumn=yes

""" Mappings
" FZF
nnoremap <C-W>e :GFiles<CR>
nnoremap <C-W><C-e> :GFiles<CR>
" RIDER
nnoremap <C-W>r :RnvimrToggle<CR>
nnoremap <C-W><C-r> :RnvimrToggle<CR>
" Terminal Mode things
tnoremap <C-x><C-c> <C-\><C-N>
autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no

" __ Plugins __
call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'cohama/lexima.vim'
Plug 'hoob3rt/lualine.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'kevinhwang91/rnvimr'

Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ray-x/lsp_signature.nvim'

call plug#end()

" Turn on Default LuaLine
:lua require('lualine').setup()
" Turn on LSP Signature
:lua require("lsp_signature").setup()

