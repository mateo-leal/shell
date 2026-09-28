import Quickshell.Hyprland
import QtQuick

QtObject {
    function workspaceFor(screen) {
        const monitor = Hyprland.monitorFor(screen)
        return monitor ? monitor.activeWorkspace : null
    }

    function activateWorkspace(name) {
        Hyprland.dispatch("workspace " + name)
    }
}