return {
    'williamboman/mason-lspconfig.nvim',
    opts = {
        handlers = {
            function(server)
                require('lspconfig')[server].setup({
                    capabilities = require('cmp_nvim_lsp').default_capabilities()
                })
            end,
        }
    }
}
