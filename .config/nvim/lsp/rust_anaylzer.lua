return {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                features = 'all',
            },
            checkOnSave = {
                enable = true,
            },
            check = {
                command = 'clippy',
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
}
