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

vim.opt.syntax = 'on'
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.undofile = true

-- Color Scheme
-- vim.cmd("colorscheme tokyonight-night")
-- Color Scheme Customization
-- vim.api.nvim_set_hl(0, "Visual", {bg = "#505050", fg = none})
-- vim.api.nvim_set_hl(0, "Search", { bg = "Green", fg = "White" })

-- even more options
vim.opt.cmdheight = 1
vim.opt.timeoutlen = 500

-- copy to clipboard
vim.o.clipboard = "unnamedplus"

local bufopts = { noremap=true, silent=true, buffer=bufnr }

-- Key Maps
vim.g.mapleader = ' ' -- map the leader
vim.g.maplocalleader = ' ' -- map the local leader
vim.opt.termguicolors = true

-- Addons

-- Color Scheme
vim.pack.add({
  { src = "https://github.com/shaunsingh/nord.nvim" },
})
vim.cmd('colorscheme retrobox') 

-- Treesitter
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", 
    version = 'main' },
})

-- LSP and Completion
vim.opt.completeopt = "menu,menuone,noselect,popup"
vim.o.autocomplete = true

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_comletion", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client_id, args.buf, {
        autotrigger = true
      })
    end
  end,
})



vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
})


---
---
---

local lsp_servers = {
  lua_ls = {
    -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) }, },
  },
  gopls = {},
  pyright = {},
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig", -- default configs for lsps
  "https://github.com/mason-org/mason.nvim",                     -- package manager
  "https://github.com/mason-org/mason-lspconfig.nvim",           -- lspconfig bridge
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- auto installer
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/chrisgrieser/nvim-origami",
}, { confirm = false })

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,

    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "grd", vim.lsp.buf.definition,
        { buffer = bufnr, desc = "vim.lsp.buf.definition()", })

      vim.keymap.set("n", "grf", vim.lsp.buf.format,
        { buffer = bufnr, desc = "vim.lsp.buf.format()", })
    end,
  })
end


-- vim.lsp.enable('pylsp')
-- require('lspconfig').pylsp.setup {
--   cmd = pylsp, -- 'pylsp' is seen as an undefined variable (nil)
-- }
-- 

-- vim.lsp.enable('pyright')
-- require('lspconfig').pyright.setup {
--   cmd = {'pyright-langserver', '--stdio'}, 
--   settings = {
--         python = {
--           analysis = {
--             autoSearchPaths = true,
--             useLibraryCodeForTypes = true,
--             diagnosticMode = 'openFilesOnly',
--           },
--       },
--   },
-- }

-- 1. Setup Pyright for Type Checking
vim.lsp.enable('pyright')
require('lspconfig').pyright.setup({
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard", -- Use "strict" if you want aggressive type checking
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      }
    }
  },
  -- Optional: Disable Pyright's hover provider if you prefer Ruff's hover
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.hoverProvider = false
  -- end,
})


-- Set diagnostic colors (replace hex codes with your preferred colors)
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff6666", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = "#ffb86c" })
vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = "#8be9fd" })
vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = "#50fa7b" })

-- Optional: Underline the text in the buffer where errors occur
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff6666" })



-- 2. Setup Ruff
-- lspconfig.ruff.setup({})





-- Recommended keymaps for LSP actions (customize as needed)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'g?', vim.diagnostic.open_float , bufopts)
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


-- Global diagnostics
vim.diagnostic.config({
    virtual_text = {
        -- Show inline diagnostic text after the line
        prefix = '●',
        spacing = 2,
        severity = {
           -- min = vim.diagnostic.severity.ERROR -- Only show WARN and ERROR in virtual text
            min = vim.diagnostic.severity.ERROR -- Only show WARN and ERROR in virtual text
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
    underline = false,         -- Underline problematic text
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

-- origami

require("origami").setup {
  keepFoldsOnJump = false, 
	useLspFoldsWithTreesitterFallback = {
		enabled = true,
		foldmethodIfNeitherIsAvailable = "indent", ---@type string|fun(bufnr: number): string
	},
	pauseFoldsOnSearch = true,
	foldtext = {
		enabled = true,
		padding = {
			character = " ",
			width = 3,  ---@type number|fun(win: number, foldstart: number, currentVirtualTextLength: number): number
			hlgroup = nil,
		},
		lineCount = {
			template = "%d lines", -- `%d` is replaced with the number of folded lines
			hlgroup = "Comment",
		},
		diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
		gitsignsCount = true, -- requires `gitsigns.nvim` or `mini.diff`
		disableOnFt = { "snacks_picker_input" }, ---@type string[]
	},
	autoFold = {
		enabled = true,
		kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
	},
	foldKeymaps = {
		setup = true, -- modifies `h`, `l`, `^`, and `$`
		closeOnlyOnFirstColumn = false, -- `h` and `^` only fold in the 1st column
		scrollLeftOnCaret = false, -- `^` should scroll left (basically mapped to `0^`)
	},
}

-- more nvim-origami fixes
-- Enable Treesitter folding for nvim-origami


vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.fillchars = {
  foldopen = "↓",
  foldclose = "→",
  foldsep = " ",
}
vim.opt.statuscolumn = "%l%C "
vim.opt.foldcolumn = "2"
vim.keymap.set("n", "<leader><CR>", "za", { noremap = true, silent =  true })
