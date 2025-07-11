-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- using bashrc
vim.opt.shell = "/bin/bash"
vim.opt.shellcmdflag = "-ic" -- interactive shell, loads ~/.bashrc
