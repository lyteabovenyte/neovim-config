-- ~/.config/nvim/lua/amir/lsp.lua
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer" }
})

local lspconfig = require("lspconfig")

lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      procMacro = { enable = true },
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
