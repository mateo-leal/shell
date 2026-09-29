import Quickshell
import Quickshell.Hyprland
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import QtQuick
import "../services"

Item {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    required property var screen
    property string specialWorkspaceName: ""
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
            text: "\ueb94"
            color: Theme.textPrimary
            font.family: Theme.iconFontFamily
            font.pixelSize: Theme.iconSize
        }

        Rectangle { width: 1; height: Theme.separatorHeight; color: Theme.divider; anchors.verticalCenter: parent.verticalCenter }

        Row {
            id: workspaceMarkers
            readonly property var targetMonitor: Hyprland.monitorFor(root.screen)

            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.workspaceMarkerSpacing

            Repeater {
                model: Hyprland.workspaces

                delegate: Rectangle {
                    required property var modelData

                    readonly property bool isSpecial: modelData.name.startsWith("special:")
                    readonly property bool belongsToMonitor: modelData.monitor === workspaceMarkers.targetMonitor
                    readonly property bool isActive: belongsToMonitor && modelData.active

                    visible: belongsToMonitor && !isSpecial
                    width: belongsToMonitor && !isSpecial
                        ? (isActive ? Theme.workspacePillWidth : Theme.workspaceDotSize)
                        : 0
                    height: Theme.workspaceDotSize
                    radius: height / 2
                    color: isActive ? Theme.accent : Theme.divider

                    MouseArea {
                        anchors.fill: parent
                        enabled: parent.belongsToMonitor && !parent.isSpecial
                        onClicked: parent.modelData.activate()
                    }
                }
            }

            Rectangle {
                visible: root.specialWorkspaceName !== ""
                width: visible ? specialName.implicitWidth + Theme.workspaceSpecialInset * 2 : 0
                height: Theme.workspaceSpecialHeight
                radius: height / 2
                color: Theme.specialWorkspaceColor

                Text {
                    id: specialName
                    anchors.centerIn: parent
                    color: Theme.specialWorkspaceText
                    font.family: Theme.uiFontFamily
                    font.pixelSize: Theme.microSize
                    font.bold: true
                    text: root.specialWorkspaceName.toUpperCase()
                    elide: Text.ElideRight
                }
            }
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
        anchors.top: parent.top
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
            width: volumeContent.implicitWidth + Theme.volumeHorizontalInset * 2
            height: Theme.actionHeight
            radius: Theme.actionRadius
            color: volumeMouse.containsMouse ? Theme.actionHover : "transparent"

            Row {
                id: volumeContent
                anchors.centerIn: parent
                spacing: 4

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.textPrimary
                    font.family: Theme.iconFontFamily
                    font.pixelSize: Theme.iconSize
                    text: {
                        const audio = Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
                        if (!audio || audio.muted) return ""
                        if (audio.volume < 0.35) return ""
                        if (audio.volume < 0.70) return ""
                        return ""
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.textPrimary
                    font.family: Theme.uiFontFamily
                    font.pixelSize: Theme.volumeTextSize
                    text: Pipewire.defaultAudioSink
                        ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
                        : "--"
                }
            }

            MouseArea {
                id: volumeMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.toggleQuickSettings()
            }
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
                font.pixelSize: Theme.iconSize
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
                font.pixelSize: Theme.iconSize
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