return {
  "echasnovski/mini.pairs",
  opts = function(_, opts)
    -- Safely initialize mappings if they're not set yet
    opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
      ["`"] = false, -- 🚫 disable backtick pairing
    })
    return opts
  end,
}
