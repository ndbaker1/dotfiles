-- ::: Basic
vim.g.mapleader = ' '
-- numbers are what this is all about!
vim.opt.number = true
vim.opt.relativenumber = true
-- mouse can be nice, i dont care what you say.
vim.opt.mouse = 'a'
-- TODO: this seems reasonable for now, can't decide what works generally.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 80
-- vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.expandtab = true
-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = 'yes'
-- not wrapping just ends up looking cleaner most of the time.
vim.opt.wrap = false
-- a terminal should never make sound.
vim.opt.vb = true
-- need to figure out what actually work here.
vim.opt.clipboard = 'unnamedplus'

-- ::: History
vim.o.swapfile = false
-- infinite undo!
vim.o.undofile = true
vim.o.undodir = vim.fn.expand('~/.config/nvim/undodir')

-- ::: Keymaps
vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = false, desc = '[Q]uit' })
vim.keymap.set('n', '<leader>w', ':w<CR>', { noremap = false, desc = '[W]rite file' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')

-- ::: Diagnostics
vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false,
})
vim.keymap.set('n', '<leader>od',
    function() vim.diagnostic.open_float({ border = "rounded" }) end,
    { desc = '[O]pen [Diagnostic]' }
)

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

-- ::: Languages
local lsp_servers = { 'rust_analyzer', 'lua_ls', 'bashls', 'gopls' }
local languages = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'toml', 'json' }

-- ::: Plugin Manager
-- https://github.com/folke/lazy.nvim
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
-- setup!
require('lazy').setup(
    {
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
            },
            init = function()
                -- This function gets run when an LSP connects to a particular buffer.
                vim.api.nvim_create_autocmd('LspAttach', {
                    callback = function(args)
                        local bufnr = args.buf

                        -- format on save
                        vim.api.nvim_create_autocmd('BufWritePost', {
                            buffer = bufnr,
                            callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end,
                        })

                        -- disable the LSP formatting so 'gq' just does wrapping
                        vim.bo[bufnr].formatexpr = nil
                        vim.bo[bufnr].formatprg = nil

                        -- native
                        vim.keymap.set('n', '<leader>da', vim.lsp.buf.code_action,
                            { buffer = bufnr, desc = '[D]o Code [A]ction' })
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
                            { buffer = bufnr, desc = 'Hover Documentation' })
                        vim.keymap.set('n', 'F', vim.lsp.buf.format,
                            { buffer = bufnr, desc = '[F]ormat Document with LPS' })
                        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                            { buffer = bufnr, desc = '[G]oto [D]eclaration' })

                        -- telescope
                        local builtins = require('telescope.builtin')
                        vim.keymap.set('n', 'gr', builtins.lsp_references,
                            { buffer = bufnr, desc = '[G]oto [R]eferences' })
                        vim.keymap.set('n', 'gd', builtins.lsp_definitions,
                            { buffer = bufnr, desc = '[G]oto [D]efinitions' })
                        vim.keymap.set('n', 'gi', builtins.lsp_implementations,
                            { buffer = bufnr, desc = '[G]oto [I]mplementations' })
                        vim.keymap.set('n', '<leader>ds', builtins.lsp_document_symbols,
                            { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
                        vim.keymap.set('n', '<leader>dws', builtins.lsp_dynamic_workspace_symbols,
                            { buffer = bufnr, desc = '[D]ynamic [W]orkspace [S]ymbols' })

                        -- server capabilities
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client then
                            -- Neovim 0.10 added native support for inlay hints
                            if client.server_capabilities.inlayHintProvider then
                                vim.lsp.inlay_hint.enable(true, { buffer = bufnr })
                            end
                        end
                    end
                })

                -- LSP capabilities to advertise from autocomplete
                local capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

                vim.lsp.config('*', {
                    capabilities = capabilities,
                })

                local lsp_configs = {}
                for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
                    local server_name = vim.fn.fnamemodify(f, ':t:r')
                    table.insert(lsp_configs, server_name)
                end
                vim.lsp.enable(lsp_configs)

                require('mason').setup()
                require('mason-lspconfig').setup({
                    ensure_installed = lsp_servers,
                })
            end,
        },

        -- Completion
        {
            'saghen/blink.cmp',
            version = "1.*",
            opts = {
                keymap = {
                    preset = 'default',
                    ['<CR>'] = { 'select_and_accept', 'fallback' },
                    ['<Tab>'] = { 'select_next', 'fallback' },
                    ['<c-j>'] = { 'select_next', 'fallback' },
                    ['<S-Tab>'] = { 'select_prev', 'fallback' },
                    ['<c-k>'] = { 'select_prev', 'fallback' },
                },
                completion = {
                    ghost_text = { enabled = true },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 0, -- no delay on showing docs.
                        window = { border = 'rounded' },
                    },
                    menu = {
                        border = 'rounded',
                        draw = {
                            columns = { { 'label' }, { 'kind' } },
                        },
                    },
                },
                sources = {
                    default = { 'lsp', 'path' },
                },
                fuzzy = { implementation = "prefer_rust" },
            },
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
