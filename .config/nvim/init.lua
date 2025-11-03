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
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = false, desc = '[Q]uit' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = false, desc = '[W]rite file' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })

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

-- [[ Languages ]]
local lsp_servers = { 'rust_analyzer', 'lua_ls', 'bashls', 'gopls' }
local languages = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'toml', 'json' }

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
    {
        -- Detect tabstop and shiftwidth automatically
        'tpope/vim-sleuth',

        -- Treesitter
        {
            'nvim-treesitter/nvim-treesitter',
            init = function()
                require('nvim-treesitter.configs').setup({
                    -- Add languages to be installed here that you want installed for treesitter
                    ensure_installed = languages,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },

        -- Display Keymappings
        {
            'folke/which-key.nvim',
            opts = { win = { border = "single" } },
            init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
            end
        },

        -- LSP Configuration & Plugins
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                { 'williamboman/mason.nvim',           opts = { ui = { border = 'rounded' } } },
                { 'williamboman/mason-lspconfig.nvim', opts = { ensure_installed = lsp_servers } },
                'nvim-telescope/telescope.nvim',
                'hrsh7th/cmp-nvim-lsp',
            },
            init = function()
                -- This function gets run when an LSP connects to a particular buffer.
                local on_attach = function(_, bufnr)
                    -- format on save
                    vim.api.nvim_create_autocmd('BufWritePost', {
                        buffer = bufnr,
                        callback = function() vim.lsp.buf.format() end,
                    })

                    -- Neovim 0.10 added native support for inlay hints
                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { buffer = bufnr })
                    end

                    -- native vim lsp
                    vim.keymap.set('n', '<leader>da', vim.lsp.buf.code_action,
                        { buffer = bufnr, desc = '[D]o Code [A]ction' })
                    vim.keymap.set('n', '<leader>od', function() vim.diagnostic.open_float({ border = "rounded" }) end,
                        { buffer = bufnr, desc = '[O]pen [Diagnostic]' })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover,
                        { buffer = bufnr, desc = 'Hover Documentation' })
                    vim.keymap.set('n', 'F', vim.lsp.buf.format,
                        { buffer = bufnr, desc = '[F]ormat Document with LPS' })

                    -- telescope lsp
                    local builtins = require('telescope.builtin')
                    vim.keymap.set('n', 'gr', builtins.lsp_references,
                        { buffer = bufnr, desc = '[G]oto [R]eferences' })
                    vim.keymap.set('n', 'gd', builtins.lsp_definitions,
                        { buffer = bufnr, desc = '[G]oto [D]efinition' })
                    vim.keymap.set('n', '<leader>ds', builtins.lsp_document_symbols,
                        { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
                    vim.keymap.set('n', '<leader>dws', builtins.lsp_dynamic_workspace_symbols,
                        { buffer = bufnr, desc = '[D]ynamic [W]orkspace [S]ymbols' })
                end

                require('mason').setup()
                require('mason-lspconfig').setup({
                    ensure_installed = lsp_servers,
                })

                local lspconfig = require("lspconfig")
                local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol
                    .make_client_capabilities())

                for _, server in ipairs(lsp_servers) do
                    lspconfig[server].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end
            end,
        },

        -- Completion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'hrsh7th/cmp-nvim-lsp',
                'saadparwaiz1/cmp_luasnip',
                { 'windwp/nvim-autopairs', opts = {} },
            },
            opts = function()
                local cmp = require('cmp')
                local luasnip = require('luasnip')

                local select_opts = { behavior = cmp.SelectBehavior.Insert, select = true }
                local cmp_modes = { 'i', 's' }

                return {
                    snippet = {
                        expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end,
                    },
                    sources = {
                        { name = 'buffer' },
                        { name = 'luasnip' },
                        { name = 'nvim_lsp' },
                        { name = 'nvim_lsp_signature_help' },
                        { name = 'path' },
                    },
                    window = {
                        completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
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
                }
            end
        },

        -- Library of nice QoL features
        {
            'folke/noice.nvim',
            event = 'VeryLazy',
            dependencies = { 'MunifTanjim/nui.nvim' },
            opts = {
                messages = { enabled = true },
                cmdline = { enabled = fast_pc() }, -- Don't waste CPU on this if slow
                lsp = {
                    override = {
                        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                        ['vim.lsp.util.stylize_markdown'] = true,
                    },
                },
                presets = {
                    lsp_doc_border = true,         -- add a border to hover docs and signature help
                    long_message_to_split = false, -- long messages will be sent to a split
                },
            },
            keys = function()
                local noice = require('noice')
                return {
                    { "<leader>sm", function() noice.cmd("telescope") end, desc = '[S]earch [M]essages' }
                }
            end
        },

        -- Theme
        {
            'catppuccin/nvim',
            name = 'catppuccin',
            priority = 1000,
            opts = { transparent_background = true },
            init = function()
                vim.cmd.colorscheme('catppuccin')
            end
        },

        -- Fancier statusline
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'catppuccin/nvim' },
            opts = { options = { theme = "catppuccin" } }
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
            opts = function()
                local actions = require('telescope.actions')
                return {
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
                }
            end,
            keys = function()
                local builtins = require('telescope.builtin')
                return {
                    { '<C-p>',      builtins.find_files,  desc = '[S]earch [F]iles' },
                    { '<leader>sh', builtins.help_tags,   desc = '[S]earch [H]elp' },
                    { '<leader>sw', builtins.grep_string, desc = '[S]earch current [W]ord' },
                    { '<leader>sg', builtins.live_grep,   desc = '[S]earch by [G]rep' },
                    { '<leader>sd', builtins.diagnostics, desc = '[S]earch [D]iagnostics' },
                    { '<leader>so', builtins.oldfiles,    desc = '[S]earch [O]ld' },
                    { '<leader>sb', builtins.builtin,     desc = '[S]earch [B]uiltins' },
                }
            end
        },

        -- File Tree
        {
            "nvim-tree/nvim-tree.lua",
            opts = {
                hijack_cursor = true,
                update_focused_file = { enable = true },
                view = {
                    width = {
                        max = '35%',
                    },
                },
            },
            init = function()
                -- use the netrw vim flags to fake netrw being setup already
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
            end,
            keys = function()
                local api = require('nvim-tree.api')
                return {
                    { '?',         api.tree.toggle_help },
                    { '<leader>e', api.tree.open,       desc = 'Open Tree [E]xplorer' }
                }
            end
        }
    },
    -- Options
    {
        ui = { border = 'rounded' }
    }
)
