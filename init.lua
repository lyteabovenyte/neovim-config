-- ~/.config/nvim/init事例

-- Bootstrap lazy.nvim
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

-- Ensure statusline is always visible
vim.o.laststatus = 2

-- Enable line numbers and relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Set leader key for vim-fugitive keymaps
vim.g.mapleader = " "

-- Require modules
require("amir.plugins")
require("amir.lsp")
require("amir.cmp")
require("amir.rust")
require("amir.treesitter")
require("copilot")
require("copilot_cmp")

-- Keymap for Ctrl+B to toggle nvim-tree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Keymaps to toggle between colorschemes
vim.keymap.set("n", "<leader>cd", ":set background=dark | colorscheme vscode<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cl", ":set background=light | colorscheme vscode<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cn", ":colorscheme nord<CR>", { noremap = true, silent = true })

-- Keymaps to toggle Copilot
vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", { noremap = true, silent = true })

-- Keymaps for navigating LSP diagnostics
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostic details" })