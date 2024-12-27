local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Install `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
    -- Options
    vim.g.mapleader = " "

    vim.opt.number = true
    vim.opt.relativenumber = true

    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true

    vim.opt.smartindent = true

    vim.opt.wrap = false
    vim.opt.hlsearch = false
    vim.opt.incsearch = true
    vim.opt.ignorecase = true

    vim.opt.termguicolors = true

    vim.opt.scrolloff = 8
    vim.opt.signcolumn = 'yes'

    vim.opt.backup = false
    vim.opt.swapfile = false

    -- Map Completion Tabbing
    local imap_expr = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true })
    end
    imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
    imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
end)

now(function()
    require('mini.hues').setup({
        background = '#101010',
        foreground = '#e0e0e0',
        saturation = 'medium',
        n_hues = 4,
    })
end)

now(function()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.icons').setup() end)
now(function()
    require('mini.statusline').setup({
        use_icons = false,
    })
end)
now(function()
    require('mini.files').setup({
        use_icons = false,
    })

    vim.keymap.set('n', '<leader>f', function() MiniFiles.open() end, { desc = 'File Explorer' })
end)

later(function() require('mini.basics').setup() end)
later(function() require('mini.move').setup() end)

later(function() require('mini.ai').setup() end)
later(function() require('mini.pick').setup() end)

later(function() require('mini.comment').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.pairs').setup() end)

now(function()
    local miniclue = require('mini.clue')
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        window = {
            delay = 0,

            config = {
                width = 'auto',
            },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })
end)

later(function() require('mini.completion').setup({
    delay = { completion = 100, info = 100, signature = 0 },
}) end)

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
    snippets = {
        -- Load custom file with global snippets first
        gen_loader.from_file('~/.config/nvim/snippets/global.json'),

        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories.
        gen_loader.from_lang(),
    },
})

later(function()
    add({
        source = "rafamadriz/friendly-snippets",
    })

end)

later(function() require('mini.git').setup() end)

now(function()
    add({
        source = 'neovim/nvim-lspconfig',
    })
    local lsp = require('lspconfig')

    -- Configuration
    lsp.lua_ls.setup({
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "MiniDeps" },
                },
            },
        },
    })

    lsp.jsonls.setup({})

    lsp.html.setup({})
    lsp.cssls.setup({})
    lsp.eslint.setup({})
    lsp.ts_ls.setup({})
end)

now(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        checkout = 'master',
        monitor = 'main',
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vimdoc' },
        highlight = { enabled = true },
    })
end)
