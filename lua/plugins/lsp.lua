return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
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
        },
      },
    },
  },
}
