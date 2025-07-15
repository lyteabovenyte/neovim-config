-- ~/.config/nvim/lua/amir/plugins.lua
require("lazy").setup({
  -- Plugin manager
  "nvim-lua/plenary.nvim",

  -- Treesitter for syntax highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
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
    end,
  },

  -- LSP
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
         模式的 = 150, -- Increased to reduce lag
          hide_during_completion = true, -- Hide during nvim-cmp popup
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = false, -- Disable panel to reduce overhead
        },
        filetypes = {
          ["*"] = true,
          markdown = false,
          text = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
        },
        copilot_node_command = 'node', -- Adjust to '/path/to/node' if needed
        logger = {
          file = vim.fn.stdpath("log") .. "/copilot.log",
          file_log_level = vim.log.levels.DEBUG,
          print_log_level = vim.log.levels.INFO,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Rust tools
  "simrat39/rust-tools.nvim",

  -- Nord colorscheme
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_cursorline_transparent = false
      vim.g.nord_enable_sidebar_background = true
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
    end,
  },

  -- VSCode colorscheme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require('vscode.colors').get_colors()
      require('vscode').setup({
        transparent = false,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = true,
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        },
      })
      vim.o.background = "dark"
      vim.cmd.colorscheme("vscode")
      require('lualine').setup({
        options = {
          theme = "vscode",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { "filename" },
          lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
          number = false,
          relativenumber = false,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
            glyphs = {
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "🗑",
                ignored = "◌",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", ":Git<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gn", "]c", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gp", "[c", { noremap = true, silent = true })
    end,
  },

  -- Auto-close brackets, parentheses, and quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        enable_check_bracket_line = true, -- Ensure pairs are added on new lines
        map_cr = true, -- Map <CR> to indent and add closing pair
        check_ts = true, -- Integrate with Treesitter
        ts_config = {
          rust = { "if", "while", "for" }, -- Enable for Rust-specific constructs
        },
        disable_filetype = { "TelescopePrompt", "text", "markdown" },
        fast_wrap = {}, -- Optional: Enable fast wrap for quick pair completion
      })
      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
})