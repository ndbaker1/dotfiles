        return {
            'neovim/nvim-lspconfig',
            dependencies = {
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim', -- bridges mason to lspconfig.nvim
                { 'windwp/nvim-autopairs', opts = {} },
                'saghen/blink.cmp',
                'folke/snacks.nvim',
            },
            config = function()
                require("mason").setup({
                    ui = { border = 'rounded' }
                })
                require("mason-lspconfig").setup({
                    -- automatically enable installed servers in 0.12
                    automatic_enable = true,
                })
            end,
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
            end,
        }
