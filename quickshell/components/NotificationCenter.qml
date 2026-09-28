import Quickshell
import QtQuick
import "../services"

PanelWindow {
    id: root

    required property var targetScreen
    property bool enabledServer: false
    property var notifications: []

    screen: root.targetScreen
    color: "transparent"
    anchors {
        top: true
        right: true
    }
    margins {
        top: Theme.popoverTopInset
        right: Theme.popoverRightInset
    }
    exclusiveZone: 0
    implicitWidth: Theme.notificationWidth
    implicitHeight: Math.min(430, Math.max(138, 92 + (root.notifications ? root.notifications.count * 76 : 0)))

    Rectangle {
        anchors.fill: parent
        radius: Theme.popoverRadius
        color: Theme.panel
        opacity: Theme.panelOpacity
        border.color: Theme.outline
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: Theme.notificationContentInset
            spacing: Theme.notificationHeaderSpacing

            Text {
                text: "NOTIFICATIONS"
                color: Theme.textSecondary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.captionSize
                font.bold: true
            }

            Text {
                visible: !root.enabledServer
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.textPrimary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.bodySize
                text: "Notification service is disabled. Another shell currently owns the desktop notification service."
            }

            Text {
                visible: root.enabledServer && (!root.notifications || root.notifications.count === 0)
                color: Theme.textSecondary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.bodySize
                text: "You're all caught up."
            }

            Repeater {
                model: root.notifications
                delegate: Rectangle {
                    required property var modelData
                    width: parent.width
                    height: 62
                    radius: Theme.notificationRadius
                    color: Theme.panelRaised
                    Column {
                        anchors.fill: parent
                        anchors.margins: 9
                        spacing: Theme.notificationCardSpacing
                        Text { width: parent.width; text: modelData.appName + " · " + modelData.summary; color: Theme.textPrimary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.bodySize; elide: Text.ElideRight }
                        Text { width: parent.width; text: modelData.body; color: Theme.textSecondary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.captionSize; elide: Text.ElideRight }
                    }
                    MouseArea { anchors.fill: parent; onClicked: modelData.dismiss() }
                }
            }
        }
    }
}