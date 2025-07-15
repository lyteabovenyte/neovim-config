-- ~/.config/nvim/lua/amir/treesitter.lua
-- [Unchanged from previous version, included for reference]
require("nvim-treesitter.configs").setup({
  ensure_installed = { "rust", "lua", "toml", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true, -- Enable Treesitter-based indentation for Rust
  },
  auto_install = true, -- Automatically install parsers for detected languages
})