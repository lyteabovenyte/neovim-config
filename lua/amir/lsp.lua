-- ~/.config/nvim/lua/amir/lsp.lua
local M = {}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common on_attach function for LSP
M.on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- Go to definition (F12 like VSCode)
  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, opts)
  
  -- Alternative keymaps if F12 doesn't work
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
end

M.capabilities = capabilities

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer" }
})

local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup({
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      procMacro = { enable = true },
      checkOnSave = {
        command = "clippy",
        extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" }
      },
    },
  },
})

-- 🔁 Format on save for Rust files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format()
  end,
})

return M