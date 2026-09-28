import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import "../services"

Row {
    spacing: Theme.traySpacing

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property var modelData
            width: Theme.trayIconSize
            height: Theme.trayIconSize

            IconImage {
                anchors.fill: parent
                source: modelData.icon
                implicitSize: Theme.trayIconSize
                mipmap: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: function(mouse) {
                    if (mouse.button === Qt.RightButton || modelData.onlyMenu)
                        modelData.display(null, Math.round(mouse.x), Math.round(mouse.y))
                    else
                        modelData.activate()
                }
            }

        }
    }
}