-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Add any additional keymaps here

-- Remove LazyVim's default <leader>q mappings
pcall(vim.keymap.del, "n", "<leader>qq")
pcall(vim.keymap.del, "n", "<leader>q")

-- Focus file tree with <leader>q
vim.keymap.set("n", "<leader>q", function()
  -- Find explorer window by filetype and focus it
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "snacks_picker_list" or ft == "neo-tree" or ft:match("^snacks") then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  -- If not found, open explorer
  Snacks.explorer.open()
end, { desc = "Focus file tree" })
