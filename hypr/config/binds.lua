local mainMod = "SUPER"
local fn      = require("config.functions")
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

local function valid_keybind(key)
    return type(key) == "string" and key:match("%S") ~= nil
end

local function flatten_keybinds(keybinds, keys)
    keys = keys or {}

    if type(keybinds) == "table" then
        for _, keybind in pairs(keybinds) do
            flatten_keybinds(keybind, keys)
        end
    elseif valid_keybind(keybinds) then
        keys[#keys + 1] = keybinds
    end

    return keys
end

local function create_bind(keybinds, action, flags)
    local get_flags = type(flags) == "function" and flags or function()
        return flags
    end

    for _, key in ipairs(flatten_keybinds(keybinds)) do
        hl.bind(key, action, get_flags(key))
    end
end

-- AZERTY fix: the number-row keys emit symbols (& é " ' ...) without Shift, so
-- binding to the digit characters fails. Bind by physical keycode instead.
-- Digit d -> evdev keycode: 1..9 => 10..18, 0 => 19
local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

-- Window manipulation
create_bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
create_bind(mainMod .. " + Q",           hl.dsp.window.close())
create_bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
create_bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
create_bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
create_bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))

-- Change focus
create_bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
create_bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
create_bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
create_bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
create_bind("ALT + Tab",           hl.dsp.window.cycle_next())

-- Move active window around workspaces & monitors
create_bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }))
create_bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }))
create_bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }))
create_bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }))
create_bind(mainMod .. " + SHIFT + " .. digitCode(1),     hl.dsp.window.move({ monitor = MONITOR1 }))
create_bind(mainMod .. " + SHIFT + " .. digitCode(2),     hl.dsp.window.move({ monitor = MONITOR2 }))
create_bind(mainMod .. " + SHIFT + " .. digitCode(3),     hl.dsp.window.move({ monitor = MONITOR3 }))
create_bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
create_bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
create_bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }))
create_bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }))
create_bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
create_bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))
for i = 1, NUM_WPM do
    local key = i % 10
    create_bind(mainMod .. " + SHIFT + CONTROL + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i }))
end
for i = 1, NUM_WPM do
    local key = i % 10
    create_bind(mainMod .. " + SHIFT + ALT + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i, follow = false }))
end

-- Special workspace toggles
-- create_bind(mainMod .. " + CONTROL + S", fn.toggle("specialws"))
create_bind(mainMod .. " + CONTROL + Escape", fn.toggle("sysmon"))
create_bind(mainMod .. " + CONTROL + M", fn.toggle("music"))
create_bind(mainMod .. " + CONTROL + C", fn.toggle("communication"))
-- create_bind(mainMod .. " + CONTROL + T", fn.toggle("todo"))

------------------
---- LAUNCHER ----
------------------

create_bind(mainMod .. " + Return",                hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
create_bind(mainMod .. " + E",                     hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
create_bind(mainMod .. " + T",                     hl.dsp.exec_cmd(launchPrefix .. EDITOR))
create_bind({mainMod .. " + C", "XF86Calculator"}, hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
create_bind(mainMod .. " + B",                     hl.dsp.exec_cmd(launchPrefix .. BROWSER))
create_bind(mainMod .. " + CONTROL + B",           hl.dsp.exec_cmd(launchPrefix .. BROWSER .. " -blank-window"))
create_bind(mainMod .. " + SHIFT + B",             hl.dsp.exec_cmd(launchPrefix .. BROWSER .. " --private-window"))
create_bind(mainMod .. " + SHIFT + slash",         hl.dsp.exec_cmd("bitwarden-desktop"))
-- create_bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
-- create_bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
create_bind(mainMod .. " + Space",      hl.dsp.exec_cmd(launchPrefix .. LAUNCHER))
-- create_bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
-- create_bind(mainMod .. " + L",          hl.dsp.exec_cmd(noctCall .. "session lock"))
-- create_bind(mainMod .. " + ALT + C",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
-- create_bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
-- create_bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
-- create_bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
-- create_bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- -- Media
-- create_bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
-- create_bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
-- create_bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
-- create_bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- -- Brightness
-- create_bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
-- create_bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

