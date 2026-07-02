local M = {}

-- Only Chromium browsers are supported
local browser = "brave"

---Generate the Hyprland window class for a webapp.
---Eg. `webapp_class("open.spotify.com")` → `"brave-open.spotify.com__-Default"`
---@param url string
function M.webapp_class(url)
    return browser .. "-" .. url .. "__-Default"
end

---Generate the command string to launch a webapp.
---Eg. `webapp_cmd("open.spotify.com")` → `"brave --app=https://open.spotify.com"`
---@param url string
function M.webapp_cmd(url)
    return browser .. " --app=https://" .. url
end

---Spawn an app or focus it if already running.
---Eg. `spawn_or_focus({ cmd = "brave", class = "brave-browser" })`
---@param app {cmd: string, class: string|nil}
---@return function
function M.spawn_or_focus(app)
    return function()
        local w = hl.get_window("class:" .. (app.class or app.cmd))
        if w then
            hl.dispatch(hl.dsp.focus({ window = w }))
        else
            hl.dispatch(hl.dsp.exec_cmd(app.cmd))
        end
    end
end

---Spawn or focus a Chromium-based webapp by URL.
---Eg. `spawn_or_focus_webapp("web.whatsapp.com")`
---@param url string
---@return function
function M.spawn_or_focus_webapp(url)
    return M.spawn_or_focus({
        cmd = M.webapp_cmd(url),
        class = M.webapp_class(url),
    })
end

---Open a URL in the browser, focusing an existing tab if one matches.
---Eg. `spawn_or_focus_url("www.youtube.com")`
---@param url string
---@return function
function M.spawn_or_focus_url(url)
    return function()
        hl.dispatch(hl.dsp.exec_cmd(browser .. " --focus='https://" .. url .. "/*' https://" .. url))
    end
end

---Spawn or focus a terminal TUI app using kitty with a unique app ID.
---Eg. `spawn_or_focus_tui({ cmd = "yazi" })`
---@param app {cmd: string, class: string|nil}
---@return function
function M.spawn_or_focus_tui(app)
    local class = app.class or app.cmd
    local cmd = "kitty --app-id " .. class .. " " .. app.cmd
    return M.spawn_or_focus({ cmd = cmd, class = app.class or app.cmd })
end

---Create a scratchpad toggle function for a given class/cmd.
---Eg. `scratchpad("music", webapp_cmd("open.spotify.com"), webapp_class("open.spotify.com"))`
---@param scratchpad_name string
---@param cmd string
---@param class string|nil
---@return function
function M.scratchpad(scratchpad_name, cmd, class)
    class = class or cmd
    return function()
        local w = hl.get_window("class:" .. class)
        if w then
            hl.dispatch(hl.dsp.workspace.toggle_special(scratchpad_name))
        else
            hl.dispatch(hl.dsp.exec_cmd(cmd, { workspace = scratchpad_name }))
            hl.dispatch(hl.dsp.workspace.toggle_special(scratchpad_name))
        end
    end
end

return M
