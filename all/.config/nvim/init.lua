local vim = vim --suppress lsp warnings, nvim v0.12 bug


vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.o.timeoutlen = 3000


-- pack (nvim 0.12)


vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    -- { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",        build = ":TSUpdate" },
    -- { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = 'main' },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/Vigemus/iron.nvim" },
    { src = "https://github.com/tpope/vim-dadbod" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
    { src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/Robitx/gp.nvim" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/Exafunction/windsurf.nvim" },
    { src = "https://github.com/nvim-mini/mini.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/jiaoshijie/undotree" },
    -- { src = "https://github.com/vim-scripts/YankRing.vim" },
    { src = "https://github.com/ojroques/nvim-osc52" },
    { src = "https://github.com/willothy/wezterm.nvim" },
    { src = "https://github.com/3rd/image.nvim" },
    { src = "https://github.com/benlubas/molten-nvim",                   build = ":UpdateRemotePlugins" },
    -- { src = "https://github.com/github/copilot.vim" },
    -- {src = "numToStr/Comment.nvim"},
})


-- local osc52 = require("osc52")

-- vim.g.clipboard = {
--   name = "osc52",
--   copy = {
--     ["+"] = osc52.copy("+"),
--     ["*"] = osc52.copy("*"),
--   },
--   paste = {
--     ["+"] = osc52.paste("+"),
--     ["*"] = osc52.paste("*"),
--   },
-- }
--
--




local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup {
    config = {
        scratch_repl = true,
        repl_definitions = {
            sh = {
                command = { "zsh" }
            },
            python = {
                command = { "ipython" },
                format = common.bracketed_paste_python,
                block_dividers = { "# %%", "#%%" },
                env = { PYTHON_BASIC_REPL = "1" },
            },
            javascript = {
                command = { "node" },
                block_dividers = { "// %%", "//%%" },
            }
        },
        repl_filetype = function(bufnr, ft)
            return ft
        end,
        dap_integration = true,
        repl_open_cmd = view.split.vertical.rightbelow("%40"),
    },
    keymaps = {
        toggle_repl = "<space>rr",
        restart_repl = "<space>rR",
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
    },
    highlight = {
        italic = true
    },
    ignore_blank_lines = true,
}

vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')



require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { 'lua_ls', 'rust_analyzer', 'pyright', 'ruff', 'eslint', 'ts_ls', 'yamlls', 'marksman', 'sqls' }, })

vim.cmd("packadd nvim.undotree")
require("undotree").setup({
    float_diff = true,      -- using float window previews diff, set this `true` will disable layout option
    layout = "left_bottom", -- "left_bottom", "left_left_bottom"
    position = "left",      -- "right", "bottom"
    ignore_filetype = {
        'undotree',
        'undotreeDiff',
        'qf',
    },
    window = {
        winblend = 30,
        border = "rounded", -- The string values are the same as those described in 'winborder'.
    },
    keymaps = {
        j = "move_next",
        k = "move_prev",
        gj = "move2parent",
        J = "move_change_next",
        K = "move_change_prev",
        ['<cr>'] = "action_enter",
        p = "enter_diffbuf",
        q = "quit",
    },
})


require('blink.cmp').setup({
    keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },
    sources = {
        default = { "lsp", "path", "buffer", "dadbod" },
        providers = { dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink", min_keyword_length = 2, score_offset = 85, }, },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust" },
})
require("mini.surround").setup()
require("mini.pairs").setup()

-- require("nvim-treesitter").setup({
--   highlight = { enable = true },
-- })
--
--
-- require("nvim-treesitter.configs").setup({
--   ensure_installed = { "lua", "rust", "python", "c", "cpp" },
--   highlight = { enable = true },
-- })
--
--

require 'nvim-treesitter'.setup {}
require("nvim-treesitter").install({ "lua", "rust", "python", "cpp" })

require 'treesitter-context'.setup { -- working only sometimes? RV 01/11/2026
    enable = true,                   -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,             -- Enable multiwindow support.
    max_lines = 0,                   -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,           -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20,        -- Maximum number of lines to show for a single context
    trim_scope = 'outer',            -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',                 -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require('gitsigns').setup {
    signs                        = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged                 = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged_enable          = true,
    signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir                 = {
        follow_files = true
    },
    auto_attach                  = true,
    attach_to_untracked          = false,
    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority                = 6,
    update_debounce              = 100,
    status_formatter             = nil,   -- Use default
    max_file_length              = 40000, -- Disable if file is longer than this (in lines)
    preview_config               = {
        -- Options passed to nvim_open_win
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
}

require("oil").setup(
    {
        columns = {
            "icon",
            "mtime",
        },
        view_options = {
            show_hidden = true,
        },
    }
)

require("gp").setup({ providers = { ollama = { disable = false, endpoint = "http://localhost:11434/v1/chat/completions", secret = "ollama_secret", }, } }) -- not really working RV 12/31/2025
-- require("lspconfig")

local builtin = require('telescope.builtin')

-- require("nvim-treesitter-textobjects").setup {
--     select = {
--         enable = true,
--         lookahead = true,
--         keymaps = {
--             ["af"] = "@function.outer",
--             ["if"] = "@function.inner",
--             ["ac"] = "@class.outer",
--             ["ic"] = "@class.inner",
--         },
--         select_modes = {
--             ['@parameter.outer'] = 'v',
--             ['@function.outer'] = 'V',
--             ['@class.outer'] = '<c-v>',
--         },
--     },
--     include_surrounding_whitespace = false,
-- }
--
local map = vim.keymap.set

map({ 't' }, '<Esc>', [[<C-\><C-n>]], { noremap = true })

map({ 'n', 'x' }, '<leader>o<CR>', ':Oil<CR>')
map({ 'n', 'x' }, '<leader>oj', ':sp .<CR>')
map({ 'n', 'x' }, '<leader>ol', ':vsp .<CR>')

map({ 'n', 'x' }, '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map({ 'n', 'x' }, '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map({ 'n', 'x' }, '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map({ 'n', 'x' }, '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- map({ 'n', 'v' }, '<leader>fm, search mail')


map({ 'n', 'x' }, '<leader>y', '"+y<CR>')
map({ 'n', 'x' }, '<leader>d', '"+d<CR>')
map({ 'n', 'x' }, '<leader>p', '"+p<CR>')
map({ 'n', 'x' }, [[\p]], '"0p<CR>')
map({ 'n', 'x' }, '<leader>w', '<c-w>', { remap = true })
map({ 'n', 'x' }, '<c-w>e', ':wq<CR>')


map('x', 'y', 'y`>')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

map({ 'n', 'x', 'o' }, 'gl', '$')
map({ 'n', 'x', 'o' }, 'gh', '0')
-- map({ 'n', 'x', 'o' }, 'gj', '<C-d>')
-- map({ 'n', 'x', 'o' }, 'gk', '<C-u>')
map({ 'n', 'x', 'o' }, '<C-j>', '<C-w>j')
map({ 'n', 'x', 'o' }, '<C-k>', '<C-w>k')
map({ 'n', 'x', 'o' }, '<C-h>', '<C-w>h')
map({ 'n', 'x', 'o' }, '<C-l>', '<C-w>l')
map({ 'n', 'x', 'o' }, '<C-Down>', '2<C-W>-')
map({ 'n', 'x', 'o' }, '<C-Up>', '2<C-W>+')
map({ 'n', 'x', 'o' }, '<C-Left>', '8<C-W><')
map({ 'n', 'x', 'o' }, '<C-Right>', '8<C-W>>')
map({ 'n', 'x', 'o' }, 'Y', 'y$')


vim.lsp.enable({ 'lua_ls' })
vim.lsp.enable({ 'pyright' })
vim.lsp.enable({ 'marksman' }) -- not working on .rc.md RV 12/31/2025
-- vim.lsp.enable({ 'tsserver' }) -- not working RV 12/30/2025
vim.lsp.enable({ 'json-lsp' })

-- opts
vim.cmd("colorscheme wildcharm")

vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.scrolloff = 8
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.undofile = true
vim.o.splitright = true
vim.o.splitbelow = true


-- keymaps

-- nnoremap <tab> >>
-- nnoremap <S-tab> <<

vim.keymap.set({ 'n', 'x' }, 'Z', 'jA')
vim.keymap.set({ 'n', 'x' }, '<leader>e', ':w<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>q', ':q<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>Q', ':q!<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>E', ':x<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>a', 'ggVG')
vim.keymap.set({ 'n', 'x' }, '<leader><CR>', '<C-^>')
vim.keymap.set({ 'n', 'x' }, '<leader>lf', vim.lsp.buf.format)
-- vim.keymap.set({ 'n', 'v' }, '<Tab>', '2W')
vim.keymap.set('n', '<esc>', ':noh<cr><esc>')
vim.keymap.set('n', '<C-l>', ':mod<CR>')

-- TODO: move to snippets RV 01/02/2026
vim.keymap.set("i", "<c-l>", function()
    return os.date("%m/%d/%Y")
end, { expr = true })

vim.keymap.set({ 'n', 'x' }, '<leader>rb,', ':DBUIToggle<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>rf,', ':DBUIFindBuffer<CR>')
vim.keymap.set({ 'n', 'x' }, '<leader>rs,', '<leader>W')

vim.keymap.set({ 'n', 'x' }, "<leader>'", ':mod<CR>')


vim.diagnostic.config({
    virtual_text = true,
    -- virtual_lines = true,
})

require("image").setup({
  backend = "kitty",
})

vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")
-- vim.g.molten_image_provider = "wezterm"
-- vim.g.molten_auto_open_output = false
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_auto_open_output = true

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.server_capabilities.semanticTokensProvider then
            vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
        end

        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function() vim.cmd("wincmd K") end,
})
