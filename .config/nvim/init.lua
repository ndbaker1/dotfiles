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
    local out = vim.fn.system({
        'git', 'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.notify("failed to clone lazy.nvim:\n\n" .. out, vim.log.levels.ERROR)
        return
    end
end
vim.opt.rtp:prepend(lazypath)
-- setup!
require('lazy').setup(
    {
        spec = {
            { import = "plugins" },
        },
        ui = { border = 'rounded' }
    }
)
