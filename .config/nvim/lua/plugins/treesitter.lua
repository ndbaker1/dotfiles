return {
    'nvim-treesitter/nvim-treesitter',
    -- main branch is required for now w/ nvim >0.12
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    init = function()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                -- skip treesitter if the buffer does not have a proper filetype.
                if vim.bo.filetype == "" then return end
                if not vim.treesitter.language.add(vim.bo.filetype) then return end
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
