require("core.allinonemess")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  spec = {
    {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
    {"folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}},
    {"ms-jpq/chadtree", branch = "chad", build = ":CHADdeps"},
    {"nvim-lualine/lualine.nvim", dependencies = { 'nvim-tree/nvim-web-devicons' }},
    {"nvim-telescope/telescope.nvim", tag = "v0.2.0", dependencies = { 'nvim-lua/plenary.nvim' }},
  },
  install = { colorscheme = { "habamax", "tokyonight" } },
  checker = { enabled = true },
})

require("core.ts")
require("lualine").setup()

vim.cmd("colorscheme tokyonight-night")
