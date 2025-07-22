return {
  {
    "IogaMaster/neocord",
    event = "VeryLazy", -- lazy-load
    enabled = true,
    config = function()
      require("neocord").setup({
        main_image = "language", -- show language-specific icon
        show_time = true, -- show elapsed timer
        global_timer = true, -- timer continues regardless of events
        debounce_timeout = 10, -- wait 10s between updates
        logo = "auto",
        workspace_text = "Working on %s",
        editing_text = "Editing %s",
        buttons = {
          { label = "GitHub", url = "https://github.com/IogaMaster/neocord" },
        },
        log_level = "info",
      })
    end,
  },
}
