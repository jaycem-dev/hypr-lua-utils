# hypr-lua-utils

Utility functions for Hyprland Lua configs.
Window class generation, app spawning/focusing, scratchpads, and webapp helpers.

By default, it uses Brave and Kitty for the WebApp and TUI commands. You can override them in the lua file.

## Functions

Main:

- `spawn_or_focus({ cmd: string, class: string | nil })` — spawn or focus an app if it's already running
- `spawn_or_focus_webapp(url: string)` — spawn or focus a webapp by URL
- `spawn_or_focus_url(url: string)` — open or focus an existing tab of the given URL
- `spawn_or_focus_tui({ cmd: string, class: string | nil })` — spawn or focus a terminal TUI app via kitty
- `scratchpad(scratchpad_name: string, cmd: string, class: string | nil)` — Toggle a named scratchpad with an assigned app with inline rules.

Helpers:

- `webapp_class(url: string)` — returns the window class for a Chromium webapp
- `webapp_cmd(url: string)` — returns the command to launch a Chromium webapp

## Usage

Copy the `utils.lua` file to your Hyprland config directory in `~/.config/hypr` and require it in your config file.

## Examples

```lua
-- Import the modules you need
local webapp_class = require("utils").webapp_class
local webapp_cmd = require("utils").webapp_cmd
local spawn_or_focus = require("utils").spawn_or_focus
local spawn_or_focus_webapp = require("utils").spawn_or_focus_webapp
local spawn_or_focus_tui = require("utils").spawn_or_focus_tui
local spawn_or_focus_url = require("utils").spawn_or_focus_url
local scratchpad = require("utils").scratchpad

-- Spawn/focus an app by cmd and class, if the class is the same as the cmd you can omit it
hl.bind("SUPER + B", spawn_or_focus({ cmd = "brave", class = "brave-browser" }))

-- Spawn/focus a terminal TUI app (class defaults to cmd)
hl.bind("SUPER + E", spawn_or_focus_tui({ cmd = "yazi" }))

-- Spawn/focus a TUI app with a unique app ID
hl.bind("SUPER + N", spawn_or_focus_tui({ cmd = "nvim -c 'some-command'", class = "nvim" }))

-- Open a URL, focusing existing tab if one matches. Not every website uses www prefix
hl.bind("SUPER + Y", spawn_or_focus_url("www.youtube.com"))

-- Spawn/focus a Chromium webapp by URL
hl.bind("SUPER + W", spawn_or_focus_webapp("web.whatsapp.com"))

-- Scratchpad toggle for a webapp
hl.bind("SUPER + M", scratchpad("music", webapp_cmd("open.spotify.com"), webapp_class("open.spotify.com")))
```

## Useful Tips

Add gaps to every special woskpace to simulate traditional scratchpads.

```lua
hl.workspace_rule({ workspace = "s[true]", gaps_out = 50 })
```
