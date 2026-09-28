-- Default config
local function default_config()
    return {
        communication = {
            discord  = { enable = true, match = { { class = "discord" } }, command = { "discord" }, move = true },
            whatsapp = {
                enable = true,
                match = { { class = "chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default", initial_title = "WhatsApp Web" } },
                command = { "/opt/helium-browser-bin/helium-wrapper --profile-directory=Default --app-id=hnpfjngllnobngcgfapefoaidbinmjnm" },
                move = true
            },
        },
        music = {
            peardesktop = {
                enable  = true,
                match   = { { class = "com.github.th-ch.youtube-music" }, { initial_title = "com.github.th-ch.youtube-music" } },
                command = { "pear-desktop" },
                move    = true,
            },

            feishin = { enable = true, match = { { class = "feishin" } }, move = true },
        },
        sysmon = {
            btop = {
                enable  = true,
                match   = { { class = "btop", title = "btop", workspace = { name = "special:sysmon" } } },
                command = { "kitty", "--class", "btop", "--title", "btop", "fish", "-C", "exec btop" },
            },
        },
        -- todo = {
        --     todoist = { enable = true, match = { { class = "todoist" } }, command = { "todoist" }, move = true },
        -- },
    }
end

-- Get a field from an object. Allows mapping camelCase to snake_case fields.
local function get_field(obj, key)
    local value = obj[key]
    if value == nil and type(key) == "string" then
        value = obj[(key:gsub("(%u)", "_%1")):lower()] -- Try convert camelCase to snake_case
    end
    return value
end

local function deep_match(actual, expected)
    if type(expected) == "table" then
        if type(actual) ~= "table" and type(actual) ~= "userdata" then
            return false
        end

        for key, sub_expected in pairs(expected) do
            if not deep_match(get_field(actual, key), sub_expected) then
                return false
            end
        end
        return true
    else
        return actual and string.find(tostring(actual), tostring(expected), 1, true)
    end
end

-- "if the client is running" etc function
local function get_clients(clients, app_config, target_special)
    local matched_clients = {}
    if app_config and app_config.match then
        for _, window in ipairs(clients) do
            for _, rule in ipairs(app_config.match) do
                local is_a_match = true
                for key, expected_value in pairs(rule) do
                    if not deep_match(get_field(window, key), expected_value) then
                        is_a_match = false
                        break
                    end
                end
                if is_a_match then
                    local client_workspace = window.workspace and window.workspace.name
                    table.insert(matched_clients, {
                        window = window,
                        is_in_place = (client_workspace == "special:" .. target_special),
                    })
                    break
                end
            end
        end
        return #matched_clients > 0, matched_clients
    end
    return false, matched_clients
end

local function shell_join(argv) -- uhh praise danny for this
    local quoted = {}
    for i, arg in ipairs(argv) do
        quoted[i] = "'" .. tostring(arg):gsub("'", [['"'"']]) .. "'"
    end
    return table.concat(quoted, " ")
end

-- Ensure every configured app is present on the special workspace: spawn it if
-- it isn't running, otherwise move any stray clients onto the workspace.
local function place_apps(apps, special_workspace)
    local target = "special:" .. special_workspace
    local clients = hl.get_windows() or {}

    for _, app in pairs(apps) do
        if app.enable then
            local is_running, target_clients = get_clients(clients, app, special_workspace)

            if not is_running then
                if app.command then
                    hl.dispatch(hl.dsp.exec_cmd(shell_join(app.command), { workspace = target }))
                end
            elseif app.move then
                for _, target_client in ipairs(target_clients) do
                    if not target_client.is_in_place then
                        hl.dispatch(hl.dsp.window.move({ window = target_client.window, workspace = target, follow = false }))
                    end
                end
            end
        end
    end
end

local function toggle(special_workspace)
    return function()
        local active_workspace = hl.get_active_special_workspace()

        -- Generic special workspace toggle: close if any is open, or open "special"
        if special_workspace == "specialws" then
            local target = active_workspace and active_workspace.name:gsub("^special:", "") or "special"
            return hl.dispatch(hl.dsp.workspace.toggle_special(target))
        end

        local on_correct_ws = active_workspace and active_workspace.name == "special:" .. special_workspace

        -- Focus workspace before apps
        if not on_correct_ws then
            hl.dispatch(hl.dsp.focus({ workspace = "special:" .. special_workspace }))
        end

        local apps = default_config()[special_workspace]
        if apps then
            place_apps(apps, special_workspace)
        end

        -- Hide workspace if already active
        if on_correct_ws then
            hl.dispatch(hl.dsp.workspace.toggle_special(special_workspace))
        end
    end
end

return {
    toggle = toggle,
}