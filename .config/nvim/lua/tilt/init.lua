-- Treat Tiltfile and *.tilt as starlark.
vim.filetype.add({
    extension = {
tilt = 'starlark',
Tiltfile = 'starlark',
},
    filename = {
        Tiltfile = 'starlark',
        tiltfile = 'starlark',
    },
})

-- nvim-lspconfig ships tilt_ls with filetypes={'tiltfile'}; override so it
-- attaches to starlark buffers (we want the starlark treesitter parser).
vim.lsp.config('tilt_ls', {
    filetypes = { 'starlark' },
    root_markers = { 'Tiltfile', '.git' },
})

-- Mason's `tilt` package has no `neovim.lspconfig` field, so mason-lspconfig
-- won't auto-enable tilt_ls. Enable it explicitly.
vim.lsp.enable('tilt_ls')
