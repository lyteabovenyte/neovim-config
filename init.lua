-- ~/.config/nvim/init.lua

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

-- Auto-save when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("write")
    end
  end,
  desc = "Auto-save file when leaving insert mode",
})

-- Set habamax colorscheme with protected call
vim.o.termguicolors = true
vim.o.background = "dark"
local status, _ = pcall(vim.cmd, "colorscheme default")
if not status then
  vim.notify("Colorscheme habamax not found!", vim.log.levels.ERROR)
end

-- Custom command to toggle colortheme contrast
vim.api.nvim_create_user_command("Contrast", function(opts)
  local mode = opts.args:lower()
  if mode == "high" then
    -- High-contrast overrides for vibrant colors
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1A2529" })
    vim.api.nvim_set_hl(0, "Keyword", { fg = "#fea2cb" }) -- Bright red for keywords
    vim.api.nvim_set_hl(0, "Constant", { fg = "#ffc95e" }) -- Bright orange for constants
    vim.notify("colorscheme set to high-contrast mode", vim.log.levels.INFO)
    vim.api.nvim_set_hl(0, "@lsp.type.struct.rust", { fg = "#c2afff" })   -- Structs: mint
    vim.api.nvim_set_hl(0, "@lsp.type.enum.rust",   { fg = "#ffaa99" })   -- Enums: salmon
    -- vim.api.nvim_set_hl(0, "@type.identifier",  { fg = "#c2afff" })   -- Traits: lavender
    vim.api.nvim_set_hl(0, "Type", { fg = "#e0fe99" }) -- Bright yellow for types
  elseif mode == "default" then
    -- Reset to default colortheme colors
    vim.cmd("colorscheme default")
    vim.notify("colorscheme set to default mode", vim.log.levels.INFO)
  else
    vim.notify("Usage: contrast {default|high}", vim.log.levels.ERROR)
  end
end, {
  nargs = 1,
  desc = "Toggle contrast (e.g., :contrast high)",
})

-- Require modules after lazy.nvim is set up
require("amir.plugins")
require("amir.lsp")
require("amir.cmp")
require("amir.rust")
require("copilot")
require("copilot_cmp")

-- Keymap for Ctrl+B to toggle nvim-tree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Keymaps for navigating LSP diagnostics
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, { scope = "line" })
  vim.notify("Showing diagnostics for current line", vim.log.levels.INFO)
end, { noremap = true, silent = false, desc = "Show diagnostic details" })
vim.keymap.set("n", "<leader>ld", function()
  vim.diagnostic.setloclist({ open = true })
  vim.notify("Listing all diagnostics in current file", vim.log.levels.INFO)
end, { noremap = true, silent = false, desc = "List all diagnostics in current file" })

-- Yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>y", '"+yy')

-- Paste from system clipboard
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- Keymaps for opening terminal in splits
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in vertical split" })

-- Rust LSP Code Actions via Telescope
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })

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

-- UnComment lines
vim.keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Toggle comment in visual mode" })
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, desc = "Toggle comment on current line" })

-- Move selected lines with shift-j and shift-k (Mac-friendly)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move visual block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move visual block up" })
-- Normal Mode version
vim.keymap.set("n", "J", ":m .+1<CR>==", { desc = "Move current line down" })
vim.keymap.set("n", "K", ":m .-2<CR>==", { desc = "Move current line up" })

-- Function signature help
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "Show signature help" })

-- Set smartindent and autoindent
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.termguicolors = true
-- Telescope keymaps
vim.keymap.set('n', '<leader>fd', ':Telescope lsp_definitions<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", { noremap = true, silent = true, desc = "List buffers" })
vim.keymap.set("n", "<leader>gc", ":Telescope git_commits<CR>", { noremap = true, silent = true, desc = "Git commits" })
vim.keymap.set("n", "<leader>gs", ":Telescope git_status<CR>", { noremap = true, silent = true, desc = "Git status" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Help tags" })
vim.keymap.set("n", "<leader>gx", function()
  local commits = {}
  require("telescope.builtin").git_commits({
    prompt_title = "Select First Commit",
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        table.insert(commits, selection.value:match("^%S+"))
        require("telescope.actions").close(prompt_bufnr)
        require("telescope.builtin").git_commits({
          prompt_title = "Select Second Commit",
          attach_mappings = function(_, map2)
            map2("i", "<CR>", function(prompt_bufnr2)
              local selection2 = require("telescope.actions.state").get_selected_entry()
              table.insert(commits, selection2.value:match("^%S+"))
              require("telescope.actions").close(prompt_bufnr2)
              if #commits == 2 then
                vim.cmd("Gdiffsplit " .. commits[1] .. ".." .. commits[2])
              end
            end)
            return true
          end,
        })
      end)
      return true
    end,
  })
end, { noremap = true, silent = true, desc = "Git diff between two commits" })

-- Buffer navigation keymaps
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bm", ":bprev<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete current buffer" })
vim.keymap.set("n", "<leader>1", ":buffer 1<CR>", { noremap = true, silent = true, desc = "Jump to buffer 1" })
vim.keymap.set("n", "<leader>2", ":buffer 2<CR>", { noremap = true, silent = true, desc = "Jump to buffer 2" })
vim.keymap.set("n", "<leader>3", ":buffer 3<CR>", { noremap = true, silent = true, desc = "Jump to buffer 3" })
vim.keymap.set("n", "<leader>4", ":buffer 4<CR>", { noremap = true, silent = true, desc = "Jump to buffer 4" })
vim.keymap.set("n", "<leader>5", ":buffer 5<CR>", { noremap = true, silent = true, desc = "Jump to buffer 5" })

-- Add ; to the end of the line (Rust specific)
vim.api.nvim_set_keymap('i', ';;', '<Esc>A;<Esc>a', { noremap = true })

-- Clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', { silent = true })

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

-- Debug keymap to test diagnostics
vim.keymap.set("n", "<leader>dt", function()
  local diagnostics = vim.diagnostic.get(0)
  vim.notify("Diagnostics in buffer: " .. vim.inspect(diagnostics), vim.log.levels.INFO)
end, { noremap = true, silent = false, desc = "Debug diagnostics in current buffer" })
