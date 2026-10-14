return {
    "nvim-tree/nvim-tree.lua",
    opts = {
        hijack_cursor = true,
        hijack_directories = { enable = true },
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
        local tree = require('nvim-tree.api').tree
        return {
            { '?',         function() tree.toggle_help() end },
            { '<leader>e', function() tree.open() end,       desc = 'Open Tree [E]xplorer' }
        }
    end
}
