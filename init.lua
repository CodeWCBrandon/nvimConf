-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- using bashrc
vim.opt.shell = "/bin/bash"
vim.opt.shellcmdflag = "-ic" -- interactive shell, loads ~/.bashrc

-- mobile compability
if vim.fn.has("unix") == 1 then
  vim.g.clipboard = {
    name = "termux-clipboard",
    copy = {
      ["+"] = "termux-clipboard-set",
      ["*"] = "termux-clipboard-set",
    },
    paste = {
      ["+"] = "termux-clipboard-get",
      ["*"] = "termux-clipboard-get",
    },
    cache_enabled = 0,
  }
end
