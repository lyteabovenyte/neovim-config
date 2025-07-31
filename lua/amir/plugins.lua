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
          debounce = 150, -- Increased to reduce lag
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

  -- Comment and Uncomment
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Rust tools
  "simrat39/rust-tools.nvim",

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

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump to the next valid object
            keymaps = {
              -- Select around/inside a block (like enum, function, etc.)
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              -- Select around/inside a class (useful for Rust enums/structs)
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
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

  -- Telescope for fuzzy finding and git integration
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
              ["<C-x>"] = require("telescope.actions").delete_buffer,
            },
            n = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
              ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
              ["<q>"] = require("telescope.actions").close,
            },
          },
          layout_strategy = "vertical",
          layout_config = {
            vertical = { width = 0.9, height = 0.9, preview_height = 0.6 },
          },
        },
        pickers = {
          find_files = {
            hidden = true, -- Show hidden files
            file_ignore_patterns = { "%.git/", "node_modules/", "%.DS_Store" },
          },
          git_commits = {
            git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit", "--" },
          },
          buffers = {
            sort_mru = true, -- Sort buffers by most recently used
            ignore_current_buffer = true, -- Skip the current buffer in the list
            previewer = true, -- Enable content preview
            show_all_buffers = true, -- Include unlisted buffers (e.g., help files)
            theme = "dropdown", -- Compact dropdown style for quicker access
            layout_config = {
              width = 0.6, -- Narrower width for buffer list
              height = 0.5, -- Compact height
              preview_width = 0.5, -- Balanced preview and list
            },
            mappings = {
              i = {
                ["<C-d>"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top, -- Delete buffer and refresh list
                ["<CR>"] = require("telescope.actions").select_default + require("telescope.actions").center, -- Select buffer and center cursor
              },
              n = {
                ["<C-d>"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top, -- Delete buffer in normal mode
                ["d"] = require("telescope.actions").delete_buffer + require("telescope.actions").move_to_top, -- Alternative delete key
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      -- Load fzf extension
      require("telescope").load_extension("fzf")
    end,
  },

  -- Color schemes
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "navarasu/onedark.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "ellisonleao/gruvbox.nvim" },
  { "sainnhe/gruvbox-material" },
  { "sainnhe/everforest" },
  { "EdenEast/nightfox.nvim" },
  { "Mofiqul/dracula.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "tanvirtin/monokai.nvim" },
  { "marko-cerovac/material.nvim" },
  { "projekt0n/github-nvim-theme" },
  { "NTBBloodbath/doom-one.nvim" },
  { "sainnhe/sonokai" },
  { "bluz71/vim-nightfly-colors", name = "nightfly" },
  { "bluz71/vim-moonfly-colors", name = "moonfly" },

  -- Telescope fzf native for faster searching
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
})