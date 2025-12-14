-- Global options
vim.opt.number = true		-- Show line numbers
vim.opt.relativenumber = true 	-- Show relative line numbers
vim.opt.mouse = 'a'		-- Enable mouse support in all modes
vim.opt.termguicolors = true	-- Enable 24-bit RGB Colors

-- Indentation and Tabs (for 2 spaces)
vim.opt.tabstop = 2		-- A tab character is 2 columns wide
vim.opt.shiftwidth = 2		-- Identation will be 2 spaces
vim.opt.expandtab = true	-- Pressing Tab inserts spaces instead of a tab character
vim.opt.softtabstop = 2		-- Pressing <TAB> insert 2 spaces, and <BS> deletes 2 spaces

-- More options
vim.opt.syntax = 'on'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.undofile = true

-- Color Scheme
-- vim.cmd("colorscheme tokyonight-night")
-- Color Scheme Customization
vim.api.nvim_set_hl(0, "Visual", {bg = "#505050", fg = none})
vim.api.nvim_set_hl(0, "Search", { bg = "Green", fg = "White" })


local bufopts = { noremap=true, silent=true, buffer=bufnr }

-- Key Maps
vim.g.mapleader = ' ' -- map the leader
vim.g.maplocalleader = ' ' -- map the local leader

-- CHADtree keys
vim.keymap.set('n', '<leader>E', '<cmd>CHADopen --always-focus<CR>', { desc = 'Open CHADtree window' })
vim.keymap.set('n', '<leader>e', '<cmd>CHADopen<CR>', { desc = 'Toggle CHADtree window' })

-- Telescope keys
vim.keymap.set('n', '<leader>f', '<cmd>Telescope find_files<CR>', { desc = 'Find files with telescope' })
vim.keymap.set('n', '<leader>g', '<cmd>Telescope live_grep<CR>', { desc = 'Live grep with telescope' })
vim.keymap.set('n', '<leader>c', '<cmd>Telescope commands<CR>', { desc = 'List ccmmands with telescope' })

-- The current quick help window
-- Learning to work with CHADtree so it is the CHADhelp binding
vim.keymap.set('n', '<leader>h', '<cmd>CHADhelp keybind<CR>', { desc = 'Toggle CHADtree help window' })

-- Keymaps for navigating diagnostics (optional, but highly recommended)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic window' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Set location list with all diagnostics' })
vim.keymap.set('n', '<leader>H', '<cmd>noh<CR>', { silent = true })

vim.api.nvim_set_keymap(  't'  ,  '<ESC>'  ,  '<C-\\><C-n>'  ,  {noremap = true}  ) -- ESC to escape from terminal mode


--- Go Developer

local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormatting', {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 1500,
        })
      end,
    })
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = false,
      convert = function(item)
        return { abbr = item.label:gsub('%b()', '') }
      end,
    })
  end

  -- autocomplete false

  -- Recommended keymaps for LSP actions (customize as needed)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- toggle inlay_hint
  vim.keymap.set('n', '<leader>q', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end)
end

vim.keymap.set('i', '<c-space>', function()
  vim.lsp.completion.get()
end)
-- Configure gopls

vim.lsp.config('gopls', {
  cmd = { '/home/daniel/go/bin/gopls' }, 
  completeUnimported = true,
})


-- gopls settings

local gopls_settings = {
  gopls = {
    buildFlags = {},
--    env = {},
    directoryFilters = {},
    analyses = {
      unusedparms = true,
      unreachable = true,
      staticcheck = true,
      shadow = true,
    },
    gofumpt = true,
    usePlaceholders = true,
    completeUnimported = true,
    deepCompletion = true,
    matcher = "Fuzzy",
    diagnosticsDelay = "250ms",
    hints = {
      rangeVariableTypes = true,
      parameterNames = true,
      constantValues = true,
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      functionTypeParameters = true,
    },
    completeUnimported = true,
    usePlaceholders = true,
    analyses = {
      unusedparams = true,
    },
  },
}

-- Autocmd to start gopls for Go files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        -- The root_dir function to find 'go.mod' in the current or parent directory
        local find_go_mod = function(filename, bufnr)
            return vim.fs.find({'go.mod', 'go.work', '.git'}, {
                upward = true,
                stop = vim.env.HOME
            })[1]
        end

        vim.lsp.start({
            name = "gopls",
            cmd = { "/home/daniel/go/bin/gopls" },
            settings = gopls_settings,
            completeUnimported = true,
            root_dir = find_go_mod, -- Use the custom function here
            on_attach = on_attach,
        })
    end,
})

-- Global diagnostics
vim.diagnostic.config({
    virtual_text = {
        -- Show inline diagnostic text after the line
        prefix = '●',
        spacing = 2,
        severity = {
            min = vim.diagnostic.severity.WARN -- Only show WARN and ERROR in virtual text
        }
    },
    signs = {
      active = true,
      text = {
           [vim.diagnostic.severity.ERROR] = "",
           [vim.diagnostic.severity.WARN]  = "",
           [vim.diagnostic.severity.INFO]  = "",
           [vim.diagnostic.severity.HINT]  = "",
      },
    },
    underline = true,         -- Underline problematic text
    update_in_insert = false, -- Don't show diagnostics while in insert mode
    severity_sort = true,     -- Sort diagnostics by severity in the list/float
    float = {
        -- Floating window settings for diagnostics
        source = true,
        border = "single",
        header = " Diagnostics ",
        format = function(diagnostic)
            return string.format("[%s] %s", diagnostic.source, diagnostic.message)
        end,
    },
})

-- Telescope
-- local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
