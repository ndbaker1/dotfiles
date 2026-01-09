return {
    settings = {
        gopls = {
            -- trigger lsp on test files that are excluded using build flags.
            buildFlags = { "-tags=integration,e2e" }
        },
    },
}
