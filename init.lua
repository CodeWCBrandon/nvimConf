-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- using bashrc
vim.opt.shell = "/bin/bash"
vim.opt.shellcmdflag = "-ic" -- interactive shell, loads ~/.bashrc

require("lspconfig").clangd.setup({
  cmd = { "clangd", "--header-insertion=never" }, -- disable header insertion
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  on_attach = function(client, bufnr)
    -- disable formatting
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    -- disable inlay hints
    if client.server_capabilities.inlayHintProvider then
      client.server_capabilities.inlayHintProvider = false
    end

    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(false, bufnr)
    end
    -- disable code lens
    if client.server_capabilities.codeLensProvider then
      client.server_capabilities.codeLensProvider = false
    end

    -- disable semantic tokens
    if client.server_capabilities.semanticTokensProvider then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- clear all LSP keymaps if you don't want any
    local keys = require("lazyvim.plugins.lsp.keymaps")
    keys.on_attach(client, bufnr) -- comment this out if LazyVim sets default keys

    -- OR: manually override keys if needed
    vim.keymap.del("n", "<leader>cr", { buffer = bufnr }) -- example: remove code action
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
    end
  end,
})
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
