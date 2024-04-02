local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

local mux = wezterm.mux

local is_windows = function() return wezterm.target_triple:find "windows" end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

if is_windows() then
  config.default_prog = { "pwsh" }
  config.keys = {
    {
      key = " ",
      mods = "CTRL",
      action = act.SendKey {
        key = " ",
        mods = "CTRL",
      },
    },
  }
else
  config.default_prog = { "zsh" }
end

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.color_scheme = "Gruvbox Dark (Gogh)"
config.prefer_egl = true

return config
