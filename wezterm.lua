local wezterm = require "wezterm"
local config = wezterm.config_builder()

local mux = wezterm.mux

local is_windows = function() return wezterm.target_triple:find "windows" end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

if is_windows() then
  config.default_prog = { "pwsh" }
else
  config.default_prog = { "zsh" }
end
config.color_scheme = "Gruvbox Dark (Gogh)"
config.prefer_egl = true

return config
