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
set clipboard=unnamedplus
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
let mapleader = " " 

" quick save & exit
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>

" fuzzy searches
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>s :Files<CR>
"nnoremap <leader>f :Rg<CR>

" buffer switching
nnoremap <leader><leader> <c-^>
nnoremap <leader>; :Buffers<CR>

" Terminal Mode things
tnoremap <C-x><C-c> <C-\><C-N>
autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no

autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)

" __ Plugins __
call plug#begin()

Plug 'hoob3rt/lualine.nvim'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
Plug 'ray-x/lsp_signature.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'

" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'simrat39/rust-tools.nvim'

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0


call plug#end()

" Turn on Default LuaLine
:lua require('lualine').setup()

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
"set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua << EOF
  local lspconfig = require'lspconfig'

  lspconfig.rust_analyzer.setup {
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        completion = {
          postfix = {
            enable = false
          },
        },
      },
    }
  }

  require'rust-tools'.setup {
    tools = { -- rust-tools options
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
  }

  local cmp = require'cmp'

  cmp.setup({

    snippet = {
      -- REQUIRED by nvim-cmp. get rid of it once we can
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },

    mapping = {
      -- Tab immediately completes. C-n/C-p to select.
      ['<Tab>'] = cmp.mapping.confirm({ select = true })
    },

    sources = cmp.config.sources({
      -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
      { name = 'nvim_lsp' },
    }, {
      { name = 'path' },
    }),

    experimental = {
      ghost_text = true,
    },
  })

EOF

