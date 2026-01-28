return {
  -- File explorer
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        update_focused_file = {
          enable = true,
        },
      })
    end,
  },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1,
    config = function()
      pcall(require("telescope").load_extension, "fzf")
    end
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "go", "typescript", "tsx", "javascript", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
      })
      vim.treesitter.language.register("markdown", "mdx")
    end,
  },

  -- Jump
  {
    "hadronized/hop.nvim",
    event = "VeryLazy",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("n", "<leader>j", hop.hint_words, { desc = "Hop words" })
    end,
  },

  -- LSP サーバー管理
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "ts_ls" },
      })
    end,
  },

  -- LSP settings
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- LSP keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })

      -- fetch capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Go LSP (gopls)
      vim.lsp.config('gopls', {
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })
      vim.lsp.enable('gopls')

      -- TypeScript/JavaScript LSP (ts_ls)
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
      })
      vim.lsp.enable('ts_ls')
    end,
  },
}
