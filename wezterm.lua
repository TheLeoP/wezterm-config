local wezterm = require "wezterm" --[[@as Wezterm]]
local act = wezterm.action
local config = wezterm.config_builder()

local mux = wezterm.mux

local is_windows = function() return wezterm.target_triple:find "windows" end

local function is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true" or pane:get_foreground_process_name():find "n?vim"
end

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

local smart_split = wezterm.action_callback(function(window, pane)
  local dim = pane:get_dimensions()
  if dim.pixel_height > dim.pixel_width then
    window:perform_action(act.SplitVertical { domain = "CurrentPaneDomain" }, pane)
  else
    window:perform_action(act.SplitHorizontal { domain = "CurrentPaneDomain" }, pane)
  end
end)

local mod = "SHIFT|CTRL"
config.disable_default_key_bindings = true
config.keys = {

  -- Font size
  { mods = "CTRL", key = "+", action = act.IncreaseFontSize },
  { mods = "CTRL", key = "-", action = act.DecreaseFontSize },
  { mods = "CTRL", key = "0", action = act.ResetFontSize },
  -- Scrollback
  { mods = mod, key = "k", action = act.ScrollByPage(-0.5) },
  { mods = mod, key = "j", action = act.ScrollByPage(0.5) },
  -- New Tab
  { mods = mod, key = "t", action = act.SpawnTab "CurrentPaneDomain" },
  -- Close Tab
  { mods = mod, key = "w", action = act.CloseCurrentTab { confirm = true } },
  -- Splits
  { mods = mod, key = "Delete", action = smart_split },
  { mods = mod, key = "°", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = mod, key = "_", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  -- Move Tabs
  { mods = mod, key = ">", action = act.MoveTabRelative(1) },
  { mods = "CTRL", key = "<", action = act.MoveTabRelative(-1) },
  -- Acivate Tabs
  { mods = mod, key = "l", action = act { ActivateTabRelative = 1 } },
  { mods = mod, key = "h", action = act { ActivateTabRelative = -1 } },
  -- show the pane selection mode, but have it swap the active and selected panes
  { mods = mod, key = "S", action = wezterm.action.PaneSelect {} },
  -- Clipboard
  { mods = mod, key = "c", action = act.CopyTo "Clipboard" },
  { mods = mod, key = "Space", action = act.QuickSelect },
  { mods = mod, key = "X", action = act.ActivateCopyMode },
  { mods = mod, key = "f", action = act.Search "CurrentSelectionOrEmptyString" },
  { mods = mod, key = "v", action = act.PasteFrom "Clipboard" },
  {
    mods = mod,
    key = "u",
    action = act.CharSelect { copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" },
  },
  { mods = mod, key = "z", action = act.TogglePaneZoomState },
  { mods = mod, key = "p", action = act.ActivateCommandPalette },
  { mods = mod, key = "d", action = act.ShowDebugOverlay },
  {
    mods = "CTRL",
    key = "Backspace",
    action = act.SendKey {
      mods = "CTRL",
      key = "Backspace",
    },
  },
  {
    mods = "CTRL",
    key = "Enter",
    action = act.SendKey {
      mods = "CTRL",
      key = "Enter",
    },
  },
}

if is_windows() then
  config.default_prog = { "pwsh", "-NoLogo" }
  table.insert(config.keys, {
    mods = "CTRL",
    key = " ",
    action = act.SendKey {
      mods = "CTRL",
      key = " ",
    },
  })
else
  config.default_prog = { "zsh" }
end

-- use _ like ^
local copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(copy_mode, {
  key = "_",
  mods = "SHIFT",
  action = act.CopyMode "MoveToStartOfLineContent",
})
config.key_tables = {
  copy_mode = copy_mode,
}

-- enable to check key events in stderr
-- wezterm needs to be openen from another terminal
-- config.debug_key_events = true

-- add support for Windows paths
config.quick_select_patterns = {
  "(?:[.\\w\\-@~:]+)?(?:\\\\+[.\\w\\-@]+)+",
}

config.default_cursor_style = "SteadyUnderline"
config.scrollback_lines = 10000
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.color_scheme = "Gruvbox Dark (Gogh)"
config.prefer_egl = true
config.font = wezterm.font {
  family = "CaskaydiaCove Nerd Font Mono",
  -- disable ligatures
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
}
config.font_size = 13

config.command_palette_font_size = 16

return config
