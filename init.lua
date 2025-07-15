-- ~/.config/nvim/init.lua

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<CR>", "<CR>", { buffer = true, noremap = true, silent = true })
  end,
})

vim.opt.rtp:prepend(lazypath)

-- Ensure statusline is always visible
vim.o.laststatus = 2

-- Enable line numbers and relative line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.g.open_command = nil

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