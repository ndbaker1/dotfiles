return {
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
                auto_show_delay_ms = 0,         -- no delay on showing docs.
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
}
