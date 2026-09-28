import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Services.Notifications
import Quickshell.Bluetooth
import QtQuick
import "components" as Components
import "services"

ShellRoot {
    id: root

    property bool notificationsEnabled: true
    property bool volumePulse: false
    property bool notificationPulse: false
    property var latestNotification: null
    property var notificationModel: notificationHost.item ? notificationHost.item.trackedNotifications : []
    property int notificationCount: notificationHost.item ? notificationHost.item.trackedNotifications.count : 0

    NetworkStatus { id: networkStatus }

    Loader {
        id: notificationHost
        active: root.notificationsEnabled
        sourceComponent: Component {
            NotificationServer {
                keepOnReload: true
                onNotification: function(notification) {
                    notification.tracked = true
                    root.latestNotification = notification
                    root.notificationPulse = true
                    notificationPulseTimer.restart()
                }
            }
        }
    }

    Connections {
        target: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null
        ignoreUnknownSignals: true
        function onVolumesChanged() {
            root.volumePulse = true
            volumePulseTimer.restart()
        }
    }

    Timer {
        id: volumePulseTimer
        interval: 2200
        onTriggered: root.volumePulse = false
    }

    Timer {
        id: notificationPulseTimer
        interval: 3200
        onTriggered: root.notificationPulse = false
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Scope {
                id: perScreen
                required property var modelData
                property bool quickSettingsVisible: false
                property bool notificationsVisible: false

                PanelWindow {
                    screen: perScreen.modelData
                    color: "transparent"
                    anchors {
                        top: true
                        left: true
                        right: true
                    }
                    implicitHeight: Theme.barHeight

                    Components.Bar {
                        anchors.fill: parent
                        screen: perScreen.modelData
                        volumePulse: root.volumePulse
                        notificationPulse: root.notificationPulse
                        latestNotification: root.latestNotification
                        ethernetConnected: networkStatus.ethernetConnected
                        connectionState: networkStatus.connectionState
                        notificationsEnabled: root.notificationsEnabled
                        notificationCount: root.notificationCount
                        onToggleQuickSettings: perScreen.quickSettingsVisible = !perScreen.quickSettingsVisible
                        onToggleNotifications: perScreen.notificationsVisible = !perScreen.notificationsVisible
                    }
                }

                Components.QuickSettings {
                    targetScreen: perScreen.modelData
                    visible: perScreen.quickSettingsVisible
                    ethernetConnected: networkStatus.ethernetConnected
                    connectionState: networkStatus.connectionState
                }

                Components.NotificationCenter {
                    targetScreen: perScreen.modelData
                    visible: perScreen.notificationsVisible
                    enabledServer: root.notificationsEnabled
                    notifications: root.notificationModel
                }
            }
        }
    }
}