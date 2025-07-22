return {
  "andweeb/presence.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    local presence = require("presence")

    -- Disable automatic updates to avoid resetting timer
    presence.setup({
      auto_update = true,
      neovim_image_text = "Playing Neovim",
      main_image = "neovim",
      enable_line_number = true,
      buttons = true,
      show_time = true,
    })
  end,
}
