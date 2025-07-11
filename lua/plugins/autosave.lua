return {
  "Pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    execution_message = {
      message = function()
        return "💾 AutoSaved!"
      end,
      dim = 0.18,
      cleaning_interval = 1250,
    },
    trigger_events = { "InsertLeave", "TextChanged" },
    conditions = {
      exists = true,
      filename_is_not = {},
      filetype_is_not = {},
      modifiable = true,
    },
    write_all_buffers = false,
    debounce_delay = 135,
  },
}
