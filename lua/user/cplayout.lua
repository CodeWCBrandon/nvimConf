local M = {}

local code_bufnr = nil

function M.setup_layout()
  vim.cmd("only")

  local columns = vim.o.columns
  local lines = vim.o.lines

  local right_width = math.floor(columns * 0.35)
  local input_height = math.floor((lines - 2) * 0.5)

  -- Vertical split (code | input/output)
  vim.cmd("vsplit")
  vim.cmd("vertical resize " .. right_width)

  vim.cmd("wincmd l")
  vim.cmd("edit input.txt")

  vim.cmd("split")
  vim.cmd("resize " .. input_height)

  vim.cmd("wincmd j")
  vim.cmd("edit output.txt")

  vim.cmd("wincmd h")
end

function M.new_cpp_file()
  vim.ui.input({ prompt = "New C++ file name: " }, function(input)
    if input and input ~= "" then
      local filename = input
      if not filename:match("%.cpp$") then
        filename = filename .. ".cpp"
      end

      vim.cmd("edit " .. filename)
      code_bufnr = vim.api.nvim_get_current_buf()
      M.setup_layout()
    end
  end)
end

function M.run_cpp_file()
  vim.cmd("write") -- Make sure the file is saved

  local cpp_file = vim.api.nvim_buf_get_name(0)

  if not cpp_file:match("%.cpp$") then
    vim.notify("Not a C++ file!", vim.log.levels.ERROR)
    return
  end

  local output_binary = "a.out"
  local compile_cmd = string.format("time g++ '%s' -o '%s'", cpp_file, output_binary)
  local run_cmd = string.format("time ./%s < input.txt > output.txt", output_binary)
  local full_cmd = compile_cmd .. " && " .. run_cmd

  print("Running: " .. full_cmd) -- 🐛 Debug command

  vim.fn.jobstart({ "bash", "-c", full_cmd }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        print("stdout: ", table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        print("stderr: ", table.concat(data, "\n"))
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("✅ Finished running!", vim.log.levels.INFO)
      else
        vim.notify("❌ Compile or run failed!", vim.log.levels.ERROR)
      end

      -- 🔁 Auto-reload output.txt window
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match("output%.txt$") then
            vim.api.nvim_win_call(win, function()
              vim.cmd("edit!")
            end)
          end
        end
      end)
    end,
  })
end

function M.insert_template()
  local template_path = vim.fn.expand("~/template.cpp")

  -- Check if template file exists
  if vim.fn.filereadable(template_path) == 0 then
    vim.notify("❌ template.cpp not found at ~/template.cpp", vim.log.levels.ERROR)
    return
  end

  -- Read template content
  local lines = vim.fn.readfile(template_path)

  -- Replace current buffer content
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify("✅ Inserted template.cpp into current buffer", vim.log.levels.INFO)
end

function M.close_layout()
  vim.cmd("wincmd h")
  vim.cmd("only")
end

return M
