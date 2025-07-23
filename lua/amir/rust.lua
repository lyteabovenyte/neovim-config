-- ~/.config/nvim/lua/amir/rust.lua
local rt = require("rust-tools")
local lsp_utils = require("amir.lsp")  -- This now gets the module table with on_attach and capabilities

rt.setup({
  server = {
    capabilities = lsp_utils.capabilities,
    on_attach = lsp_utils.on_attach,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = true,
        check = {
          command = "clippy",
        }
      },
    },
  },
  tools = {
    inlay_hints = {
      auto = true,
    },
  }
})