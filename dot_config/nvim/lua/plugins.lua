return {
  -- File explorer
  { "stevearc/oil.nvim", opts = {}, dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1,
    config = function()
      pcall(require("telescope").load_extension, "fzf")
    end
  },

  -- (Optional) LSP / Treesitter は後で
  -- { "neovim/nvim-lspconfig" },
  -- { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
}

