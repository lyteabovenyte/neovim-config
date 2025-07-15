-- ~/.config/nvim/lua/amir/treesitter.lua
require("nvim-treesitter.configs").setup {
  ensure_installed = { "rust", "lua", "toml", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
