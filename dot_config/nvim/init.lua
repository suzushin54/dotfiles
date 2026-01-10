-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- Load plugins
require("lazy").setup(require("plugins"))

-- Keymaps (IDE ライク検索)
local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",  { desc = "Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",    { desc = "Buffers" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc="Symbols" })

-- ファイラー（oil）
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })

-- ファイルツリー(nvim-tree)
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<cr>", { desc = "Find file in tree" })
map("n", "<leader>et", "<cmd>NvimTreeFocus<cr>", { desc = "Focus on file tree" })
