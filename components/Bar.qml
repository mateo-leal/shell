import Quickshell
import Quickshell.Hyprland
import Quickshell.Bluetooth
import QtQuick
import "../services"

Item {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    required property var screen
    property bool ethernetConnected: false
    property string connectionState: "Checking"
    property bool notificationsEnabled: false
    property int notificationCount: 0
    property bool volumePulse: false
    property bool notificationPulse: false
    property var latestNotification: null

    signal toggleQuickSettings()
    signal toggleNotifications()

    Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: Theme.barInset
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.barSpacing

        Text {
            text: ""
            color: Theme.textPrimary
            font.family: Theme.iconFontFamily
            font.pixelSize: Theme.iconSize
        }

        Rectangle { width: 1; height: Theme.separatorHeight; color: Theme.divider; anchors.verticalCenter: parent.verticalCenter }

        Text {
            color: Theme.textPrimary
            font.pixelSize: Theme.iconSize
            text: {
                const monitor = Hyprland.monitorFor(root.screen)
                return monitor && monitor.activeWorkspace ? "󰍹 " + monitor.activeWorkspace.name : "󰍹"
            }
            font.family: Theme.iconFontFamily
        }

        Text {
            color: Theme.textSecondary
            font.family: Theme.uiFontFamily
            font.pixelSize: Theme.titleSize
            text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
            elide: Text.ElideRight
            // width: Math.min(260, Math.max(0, root.width * 0.18))
        }
    }

    DynamicIsland {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        volumePulse: root.volumePulse
        notificationPulse: root.notificationPulse
        latestNotification: root.latestNotification
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: Theme.barRightInset
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.statusSpacing

        Text {
            color: Theme.textPrimary
            font.family: Theme.iconFontFamily
            font.pixelSize: Theme.iconSize
            text: root.ethernetConnected ? "󰈀" : "󰈁"
        }

        Text {
            color: Theme.textPrimary
            font.family: Theme.iconFontFamily
            font.pixelSize: Theme.iconSize
            text: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.enabled ? "󰂯" : "󰂲"
        }

        Rectangle {
            width: 1
            height: Theme.separatorHeight
            color: Theme.divider
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: Theme.actionWidth
            height: Theme.actionHeight
            radius: Theme.actionRadius
            color: settingsMouse.containsMouse ? Theme.actionHover : "transparent"

            Text {
                anchors.centerIn: parent
                text: "󰒓"
                color: Theme.textPrimary
                font.family: Theme.iconFontFamily
                font.pixelSize: Theme.actionIconSize
            }

            MouseArea {
                id: settingsMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleQuickSettings()
            }
        }

        Rectangle {
            width: Theme.actionWidth
            height: Theme.actionHeight
            radius: Theme.actionRadius
            color: notificationMouse.containsMouse ? Theme.actionHover : "transparent"

            Text {
                anchors.centerIn: parent
                text: root.notificationsEnabled ? "󰂚" + (root.notificationCount > 0 ? root.notificationCount : "") : "󰂛"
                color: Theme.textPrimary
                font.family: Theme.iconFontFamily
                font.pixelSize: Theme.notificationIconSize
            }

            MouseArea {
                id: notificationMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleNotifications()
            }
        }

        StatusTray { anchors.verticalCenter: parent.verticalCenter }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.textPrimary
            font.family: Theme.uiFontFamily
            font.pixelSize: Theme.clockSize
            font.bold: true
            text: Qt.formatDateTime(clock.date, Theme.clockFormat)
        }
    }
}