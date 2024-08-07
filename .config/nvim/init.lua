-- [[ Editor ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.ttyfast = true
vim.o.mouse = 'a'
vim.o.encoding = 'utf-8'
vim.o.hidden = true
vim.o.incsearch = true
vim.o.title = true
vim.o.showcmd = true
vim.o.hlsearch = false
vim.o.clipboard = 'unnamedplus'
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert', 'preview' }

-- [[ Formatting ]]
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.tabpagemax = 50
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.textwidth = 80
vim.o.whichwrap = 'bs<>[]'
vim.o.wrap = false

-- [[ History ]]
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fn.expand('~/.config/nvim/undodir')

-- [[ Keymaps ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = vim.g.mapleader
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = false, desc = 'quit' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = false, desc = 'write file' })

-- helper util to check host power
local fast_pc = function()
    local bogomips = tonumber(vim.fn.system({
        'awk',
        'BEGIN { IGNORECASE = 1 } /bogomips/{print $3; exit}',
        '/proc/cpuinfo',
    }))
    if bogomips == nil then
        return true            -- if we failed to get a value then lets just enable it 🙃
    else
        return bogomips > 2000 -- disable when the system isnt powerful enough
    end
end

-- [[ Lazy.nvim ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git', 'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
-- Plugins
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',
        -- Treesitter
        'nvim-treesitter/nvim-treesitter',

        -- Display Keymappings
        {
            'folke/which-key.nvim',
            opts = { win = { border = "single" } },
            config = function(_, opts)
                vim.o.timeout = true
                vim.o.timeoutlen = 300
                require('which-key').setup(opts)
            end,
        },

        -- LSP Configuration & Plugins
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',

                'simrat39/inlay-hints.nvim', -- Inlay Hints
                'simrat39/rust-tools.nvim',  -- Rust Inlay Hints
            },
        },

        -- Completion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'hrsh7th/cmp-nvim-lsp',
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                { 'windwp/nvim-autopairs', config = function() require("nvim-autopairs").setup() end },
            },
        },

        -- Library of nice QoL features
        {
            'folke/noice.nvim',
            event = 'VeryLazy',
            dependencies = { 'MunifTanjim/nui.nvim' },
            opts = {
                messages = { enabled = true },
                cmdline = { enabled = fast_pc() }, -- Don't waste on this if slow
                lsp = {
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                    },
                },
                presets = {
                    lsp_doc_border = true,         -- add a border to hover docs and signature help
                    long_message_to_split = false, -- long messages will be sent to a split
                }
            }
        },

        -- Theme
        {
            'catppuccin/nvim',
            name = 'catppuccin',
            priority = 1000,
            opts = { transparent_background = true },
            config = function(_, opts)
                require('catppuccin').setup(opts)
                vim.cmd.colorscheme('catppuccin')
            end
        },

        -- Fancier statusline
        {
            'nvim-lualine/lualine.nvim',
            opts = {
                options = {
                    theme = "catppuccin"
                }
            }
        },

        -- Fuzzy Finder (files, lsp, etc)
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build =
                        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && ' ..
                        'cmake --build build --config Release && ' ..
                        'cmake --install build --prefix build'
                }
            },
        },

        -- File Tree
        {
            "nvim-tree/nvim-tree.lua",
            opts = {
                hijack_cursor = true,
                update_focused_file = {
                    enable = true,
                },
                view = {
                    width = {
                        max = '35%',
                    },
                },
                on_attach = function(buf)
                    local api = require('nvim-tree.api')
                    api.config.mappings.default_on_attach(buf)
                    vim.keymap.set('n', '?', api.tree.toggle_help)
                end
            },
            config = function(_, opts)
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
                require("nvim-tree").setup(opts)
            end
        }
    },
    -- Options
    {
        ui = { border = 'rounded' }
    }
)

-- [[ Languages ]]
local lsp_servers = { 'rust_analyzer', 'lua_ls', 'bashls' }
local languages = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'toml', 'json' }

-- [[ Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = languages,
    highlight = { enable = true },
    indent = { enable = true },
})

-- [[ Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local actions = require('telescope.actions')
local builtins = require('telescope.builtin')
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<esc>'] = actions.close,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-k>'] = actions.move_selection_previous,
            }
        },
        layout_strategy = 'vertical',
        path_display = { 'smart' },
    }
})
vim.keymap.set('n', '<C-p>', builtins.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', builtins.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', builtins.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtins.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtins.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>so', builtins.oldfiles, { desc = '[S]earch [O]ld' })
vim.keymap.set('n', '<leader>sb', builtins.builtin, { desc = '[S]earch [B]uiltins' })
vim.keymap.set('n', '<leader>e', require('nvim-tree.api').tree.open, { desc = 'Open Tree [E]xplorer' })
vim.keymap.set('n', '<leader>sm', function() require("noice").cmd("telescope") end, { desc = '[S]earch [M]essages' })

-- [[ Completion ]]
local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Insert, select = true }
local cmp_modes = { 'i', 's' }
local source_map = {
    buffer = 'Ω',
    luasnip = '⋗',
    nvim_lsp = 'λ',
    nvim_lsp_signature_help = 'λ',
    path = '🖫',
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = (function()
        local sources = {}
        for key, _ in pairs(source_map) do table.insert(sources, { name = key }) end
        return sources
    end)(),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, item)
            item.menu = source_map[entry.source.name]
            return item
        end
    },
    mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<c-j>'] = cmp.mapping(cmp.mapping.select_next_item(select_opts), cmp_modes),
        ['<c-k>'] = cmp.mapping(cmp.mapping.select_prev_item(select_opts), cmp_modes),
        ['<c-space>'] = cmp.mapping(function()
            if not cmp.visible() then
                cmp.complete()
            else
                cmp.select_next_item(select_opts)
            end
        end),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, cmp_modes),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, cmp_modes),
    },
})

-- [[ LSPConfig ]]
local lspconfig = require('lspconfig')
-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = 'Format current buffer with LSP' })

    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*',
        command = ':Format',
    })

    nmap('<F2>', vim.lsp.buf.rename, 'Rename')
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    nmap('gr', builtins.lsp_references, '[G]oto [R]eferences')
    nmap('gd', builtins.lsp_definitions, '[G]oto [D]efinition')
    nmap('<C-LeftMouse> <LeftMouse>', builtins.lsp_definitions, '[Mouse] Goto Definition')

    nmap('<leader>da', vim.lsp.buf.code_action, '[D]o Code [A]ction')
    nmap('<leader>ds', builtins.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>dws', builtins.lsp_dynamic_workspace_symbols, '[D]ynamic [W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- shortcut to use formatting command
    nmap('F', ':Format<CR>', 'Format Document with LPS')
end

-- [[ Mason ]]
require('mason').setup({
    ui = {
        border = 'rounded'
    }
})
-- Ensure the servers above are installed
require('mason-lspconfig').setup({
    -- add language servers that arent managed by mason
    ensure_installed = lsp_servers,
})
require('mason-lspconfig').setup_handlers({
    function(lsp)
        lspconfig[lsp].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ['rust_analyzer'] = function()
        require('rust-tools').setup({
            server = {
                on_attach = on_attach,
                capabilities = capabilities,
            }
        })
    end,
})

-- [[ ETC ]]

if vim.g.vscode then
    -- dont load anything else other than configs if this is used as a backend vscode
    return
end
