-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- for mobile compability
local modes = { "n", "i", "v", "t", "x", "s", "c" }

for _, mode in ipairs(modes) do
  vim.keymap.set(mode, "`", "<Esc>", { noremap = true, silent = true })
end

vim.keymap.set("i", "<C-h>", "<C-w>")

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

-- Copy to input
vim.keymap.set("n", "<leader>pi", function()
  cp_layout.paste_clipboard_to_input()
end, { desc = "Paste to input" })

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

-- Lua function to perform keyword substitution in a line range
function _G.change_keyword_in_range(start_line, end_line)
  local from = vim.fn.input("Keyword to change: ")
  if from == "" then
    vim.notify("⚠️ No keyword provided, aborting.", vim.log.levels.WARN)
    return
  end

  local to = vim.fn.input("Replace with: ")
  if to == "" then
    vim.notify("⚠️ No replacement provided, aborting.", vim.log.levels.WARN)
    return
  end

  -- Escape special characters
  local esc_from = vim.fn.escape(from, [[\/]])
  local esc_to = vim.fn.escape(to, [[\/]])

  -- Construct and run the substitution command
  local cmd = string.format("%d,%ds/%s/%s/g", start_line, end_line, esc_from, esc_to)
  vim.cmd(cmd)

  vim.notify(
    ("✅ Replaced '%s' → '%s' in lines %d–%d"):format(from, to, start_line, end_line),
    vim.log.levels.INFO
  )
end

vim.cmd([[
  xnoremap <silent> <leader>ck :<C-u>lua change_keyword_in_range(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])<CR>
]])
