return {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',

    dependencies = {
        'hrsh7th/cmp-buffer',
        'FelipeLema/cmp-async-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-calc',

        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
    },
    config = function(cmp, opts)
        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'luasnip' },
                { name = 'async_path' },
                { name = 'calc' },
                { name = 'cmdline' },
            }),
            formatting = {
                format = require('lspkind').cmp_format({
                    with_text = true,
                    maxwidth = 50,
                    before = function(entry, vim_item)
                        vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                        return vim_item
                    end
                })
            },
        }
    end
}
