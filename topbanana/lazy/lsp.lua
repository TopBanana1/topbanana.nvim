return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",           -- LSP manager
        "williamboman/mason-lspconfig.nvim", -- Mason integration with lspconfig
        "hrsh7th/cmp-nvim-lsp",  -- LSP completion source
        "hrsh7th/cmp-buffer",    -- Buffer completion source
        "hrsh7th/cmp-path",      -- Path completion source
        "hrsh7th/cmp-cmdline",   -- Command-line completion source
        "hrsh7th/nvim-cmp",      -- Main completion engine
        "L3MON4D3/LuaSnip",      -- Snippet engine
        "saadparwaiz1/cmp_luasnip", -- Luasnip completion source
        "j-hui/fidget.nvim",     -- LSP status UI
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "tsserver",
                "asm_lsp",       -- Assembly LSP
                "clangd",        -- C & C++ LSP
                "pyright",       -- Python LSP
            },
            handlers = {
                function(server_name) -- Default handler
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,

                ["clangd"] = function()
                    require("lspconfig").clangd.setup {
                        capabilities = capabilities,
                        cmd = { "clangd", "--background-index" },
                    }
                end,

                ["asm_lsp"] = function()
                    require("lspconfig").asm_lsp.setup {
                        capabilities = capabilities,
                    }
                end,

                ["pyright"] = function()
                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                    }
                end,
            }
        })

        -- Auto-completion settings
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- Snippet expansion
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- Snippet source
            }, {
                { name = 'buffer' },
            })
        })

        -- Diagnostics configuration
        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}

