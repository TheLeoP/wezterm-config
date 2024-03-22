local wezterm = require "wezterm"
local config = wezterm.config_builder()

local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

config.default_prog = { "pwsh" }
config.color_scheme = "Gruvbox Dark (Gogh)"

return config
