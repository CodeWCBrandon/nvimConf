-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- for mobile compability
vim.keymap.set({ "n", "v", "s", "o", "i", "t", "c" }, "`", "<Esc>")

-- load CPLayout
local cp_layout = require("user.cplayout")

-- setup layout
vim.api.nvim_create_user_command("CPLayout", function()
  cp_layout.setup_layout()
end, {})

-- New C++ file and CP layout
vim.keymap.set("n", "<leader>nc", function()
  cp_layout.new_cpp_file()
end, { desc = "New C++ file and layout" })

-- Layout close
vim.keymap.set("n", "<leader>cx", function()
  cp_layout.close_layout()
end, { desc = "Close CP layout" })

-- Code run
vim.keymap.set("n", "<leader>cr", function()
  cp_layout.run_cpp_file()
end, { desc = "Run C++ with input/output" })

vim.keymap.set("n", "<leader>ct", function()
  cp_layout.insert_template()
end, { desc = "Insert C++ template" })

vim.keymap.set("n", "<leader>cp", ":CPLayout<CR>", { desc = "Setup CP layout" })

-- KEYMAPS --
-- Ctrl + Backspace deletes previous word in insert mode
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word on ctrl+Backspace" })

-- Moving line of code up and down
local opts = { noremap = true, silent = true }

-- Normal mode
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", opts)
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", opts)

-- Visual mode
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", opts)
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", opts)

-- Insert mode
vim.keymap.set("i", "<M-Up>", "<Esc>:m .-2<CR>==", opts)
vim.keymap.set("i", "<M-Down>", "<Esc>:m .+1<CR>==", opts)

-- Change Keywords
vim.keymap.set("v", "<leader>ck", function()
  -- Get the range of selected lines
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Prompt for the keyword to replace
  vim.ui.input({ prompt = "Keyword to change: " }, function(from_word)
    if not from_word or from_word == "" then
      return
    end

    -- Prompt for the replacement keyword
    vim.ui.input({ prompt = "Replace with: " }, function(to_word)
      if to_word == nil then
        return
      end

      -- Escape special characters (optional but recommended)
      local escaped_from = vim.fn.escape(from_word, "\\/") -- escape / and \
      local escaped_to = vim.fn.escape(to_word, "\\/")

      -- Perform the substitution over the visual range
      local cmd = string.format(":%d,%ds/\\<%s\\>/%s/g", start_line, end_line, escaped_from, escaped_to)
      vim.cmd(cmd)

      vim.notify(
        string.format("✅ Replaced '%s' → '%s' in lines %d–%d", from_word, to_word, start_line, end_line),
        vim.log.levels.INFO
      )
    end)
  end)
end, { desc = "Change keyword in visual selection" })
