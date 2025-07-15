-- ~/.config/nvim/lua/amir/rust.lua
local rt = require("rust-tools")

rt.setup({
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        check = {
          command = "check",
        }
      },
    },
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  }
})
