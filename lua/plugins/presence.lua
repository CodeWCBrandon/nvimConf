return {
  "andweeb/presence.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("presence").setup({
      -- customize status here
      neovim_image_text = "Playing Neovim",
      main_image = "neovim",
      enable_line_number = true,
      buttons = true,
      show_time = true,
    })
  end,
}
