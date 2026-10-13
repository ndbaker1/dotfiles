        return {
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
        }
