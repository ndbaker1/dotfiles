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
    { desc = '[O]pen [D]iagnostic' }
)

-- ::: Plugins
-- see: https://github.com/folke/lazy.nvim
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
            branch = 'master',
            lazy = false,
            build = ':TSUpdate',
            init = function()
                require('nvim-treesitter.configs').setup({
                    -- Add languages to be installed here that you want installed for treesitter
                    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'toml', 'json' },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },

        -- Display Keymappings
        {
            'folke/which-key.nvim',
            opts = { win = { border = "single" } },
        },

        -- LSP Configuration & Plugins
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                { 'williamboman/mason.nvim',           opts = { ui = { border = 'rounded' } } },
                { 'williamboman/mason-lspconfig.nvim', opts = {} }, -- bridges mason to lspconfig.nvim
                { 'windwp/nvim-autopairs',             opts = {} },
                'saghen/blink.cmp',
                'folke/snacks.nvim',
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
                        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,
                            { buffer = bufnr, desc = '[R]e[n]ame' })
                        vim.keymap.set('n', '<leader>da', vim.lsp.buf.code_action,
                            { buffer = bufnr, desc = '[D]o Code [A]ction' })
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover,
                            { buffer = bufnr, desc = 'Hover Documentation' })
                        vim.keymap.set('n', 'F', vim.lsp.buf.format,
                            { buffer = bufnr, desc = '[F]ormat Document with LPS' })
                        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                            { buffer = bufnr, desc = '[G]oto [D]eclaration' })

                        -- snacks.nvim pickers
                        vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end,
                            { buffer = bufnr, desc = '[G]oto [R]eferences' })
                        vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end,
                            { buffer = bufnr, desc = '[G]oto [D]efinitions' })
                        vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations() end,
                            { buffer = bufnr, desc = '[G]oto [I]mplementations' })
                        vim.keymap.set('n', '<leader>ds', function() Snacks.picker.lsp_symbols() end,
                            { buffer = bufnr, desc = '[D]ocument [S]ymbols' })
                        vim.keymap.set('n', '<leader>dws', function() Snacks.picker.lsp_workspace_symbols() end,
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
                vim.lsp.config('*', { capabilities = capabilities })

                for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
                    -- get last component of file and strip extension
                    local server_name = vim.fn.fnamemodify(f, ':t:r')
                    vim.lsp.enable(server_name)
                end
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
            "folke/snacks.nvim",
            ---@type snacks.Config
            opts = {
                -- helps avoid loaing plugins on big files.
                bigfile = { enabled = true },
                -- swap the default nvim notifier with snacks.
                notifier = { enabled = true },
                picker = {
                    enabled = true,
                    layout = {
                        layout = {
                            box = "vertical",
                            width = 0.8,
                            height = 0.9,
                            { win = "preview", border = true, title = "{preview:Preview}" },
                            { win = "list",    border = true, title = "Results" },
                            { win = "input",   border = true, title = "{title} {live} {flags}", height = 1 },
                        },
                    },
                },
            },
            keys = {
                { '<C-p>',      function() Snacks.picker.files() end,         desc = '[S]earch [F]iles' },
                { '<leader>sh', function() Snacks.picker.help() end,          desc = '[S]earch [H]elp' },
                { '<leader>sw', function() Snacks.picker.grep_word() end,     desc = '[S]earch current [W]ord' },
                { '<leader>sg', function() Snacks.picker.grep() end,          desc = '[S]earch by [G]rep' },
                { '<leader>sd', function() Snacks.picker.diagnostics() end,   desc = '[S]earch [D]iagnostics' },
                { '<leader>so', function() Snacks.picker.recent() end,        desc = '[S]earch [O]ld' },
                { '<leader>sl', function() Snacks.picker.git_log() end,       desc = '[S]earch Git [L]og' },
                { "<leader>sn", function() Snacks.picker.notifications() end, desc = '[S]earch [N]otifications' },
                { '<leader>sp', function() Snacks.picker() end,               desc = '[S]earch [P]ickers' },
            },
        },

        -- Library of nice QoL plugins
        {
            'folke/noice.nvim',
            event = 'VeryLazy',
            opts = {
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
            },
        },

        -- Color Theme
        {
            'catppuccin/nvim',
            name = 'catppuccin',
            priority = 1000,
            opts = { transparent_background = true },
            init = function() vim.cmd.colorscheme('catppuccin') end
        },

        -- Fancier statusline
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'catppuccin/nvim' },
            opts = { options = { theme = "catppuccin" } },
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

    -- lazy.nvim Options
    {
        ui = { border = 'rounded' }
    }
)
