        return {
            "folke/snacks.nvim",
            ---@type snacks.Config
            opts = {
                -- helps avoid loaing plugins on big files.
                bigfile = { enabled = true },
                -- swap the default nvim notifier with snacks.
                notifier = { enabled = true },
                picker = {
                    hidden = true,
                    ignored = false,
                    sources = {
                        files = {
                            hidden = true,
                            ignored = false,
                        },
                    },
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
        }
