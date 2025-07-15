-- ~/.config/nvim/init.lua
-- [Unchanged from previous version, included for reference]
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
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
vim.g.open_command = nil

-- Set leader key for vim-fugitive keymaps
vim.g.mapleader = " "

-- Indentation settings for better brace handling
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.tabstop = 4 -- Number of spaces per tab
vim.o.shiftwidth = 4 -- Number of spaces for indentation
vim.o.softtabstop = 4 -- Number of spaces for tab key in insert mode

-- Filetype-specific indentation for Rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.bo.autoindent = true
    vim.bo.smartindent = false -- Disable smartindent to avoid conflicts with Treesitter
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.indentexpr = '' -- Disable indentexpr to rely on Treesitter
  end,
})

-- Quickfix buffer keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, noremap = true, silent = true })
  end,
})

-- Require modules after lazy.nvim is set up
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
vim.keymap.set("n", "<leader>ld", function()
  vim.diagnostic.setloclist({ open = true })
end, { noremap = true, silent = true, desc = "List all diagnostics in current file" })

-- Keymaps for opening terminal in splits
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in vertical split" })

-- Keymaps for switching between split windows
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "Move to left window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "Move to right window" })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { noremap = true, silent = true, desc = "Cycle to next window" })

-- Keymap to run cargo check and populate quickfix list
vim.keymap.set("n", "<leader>cc", ":lua RunCargoCheck()<CR>", { noremap = true, silent = true, desc = "Run cargo check" })

-- Keymaps for navigating quickfix list (cargo check errors)
vim.keymap.set("n", "<leader>]e", ":try | cnext | wincmd p | catch | cfirst | wincmd p | endtry<CR>", { noremap = true, silent = true, desc = "Next cargo check error" })
vim.keymap.set("n", "<leader>[e", ":try | cprev | wincmd p | catch | clast | wincmd p | endtry<CR>", { noremap = true, silent = true, desc = "Previous cargo check error" })

-- Function to run cargo check and populate quickfix list
function RunCargoCheck()
  vim.opt.errorformat = "%f:%l:%c: %t%*[^:]: %m,%f:%l:%c %m,%-G%.%#"
  vim.cmd("cd %:p:h")
  local output = vim.fn.systemlist("cargo check")
  vim.fn.setqflist({}, "r", { title = "Cargo Check", lines = output })
  vim.cmd("copen | cfirst")
end

-- Configure makeprg for cargo check
vim.opt.makeprg = "cargo"