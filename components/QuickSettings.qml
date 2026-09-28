import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Controls
import "../services"

PanelWindow {
    id: root

    required property var targetScreen
    property bool ethernetConnected: false
    property string connectionState: "Checking"

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
    implicitWidth: Theme.popoverWidth
    implicitHeight: 344

    Rectangle {
        anchors.fill: parent
        radius: Theme.popoverRadius
        color: Theme.panel
        opacity: Theme.panelOpacity
        border.color: Theme.outline
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: Theme.popoverContentInset
            spacing: Theme.controlsContentSpacing

            Text {
                text: "CONTROLS"
                color: Theme.textSecondary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.captionSize
                font.bold: true
            }

            Row {
                width: parent.width
                spacing: Theme.controlGridSpacing

                Rectangle {
                    width: (parent.width - 9) / 2
                    height: 50
                    radius: 10
                    color: Theme.panelRaised
                    Column {
                        anchors.centerIn: parent
                        Text { text: "ETHERNET"; color: Theme.textSecondary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.microSize; font.bold: true }
                        Text { text: root.connectionState; color: Theme.textPrimary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.bodySize }
                    }
                }

                Rectangle {
                    width: (parent.width - 9) / 2
                    height: 50
                    radius: 10
                    color: Theme.panelRaised
                    Column {
                        anchors.centerIn: parent
                        Text { text: "BLUETOOTH"; color: Theme.textSecondary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.microSize; font.bold: true }
                        Text {
                            text: Bluetooth.defaultAdapter ? (Bluetooth.defaultAdapter.enabled ? "On" : "Off") : "Unavailable"
                            color: Theme.textPrimary
                            font.family: Theme.uiFontFamily
                            font.pixelSize: Theme.bodySize
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: Bluetooth.defaultAdapter !== null
                        onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider }

            Text {
                text: "OUTPUT VOLUME"
                color: Theme.textSecondary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.captionSize
                font.bold: true
            }

            Row {
                width: parent.width
                spacing: Theme.controlVolumeSpacing
                Text {
                    width: 36
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.textPrimary
                    font.family: Theme.uiFontFamily
                    font.pixelSize: Theme.bodySize
                    text: Pipewire.defaultAudioSink ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%" : "--"
                }
                Slider {
                    width: parent.width - 45
                    from: 0
                    to: 1.5
                    value: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio.volume : 0
                    enabled: Pipewire.defaultAudioSink !== null
                    onMoved: if (Pipewire.defaultAudioSink) Pipewire.defaultAudioSink.audio.volume = value
                }
            }

            Row {
                width: parent.width
                spacing: Theme.controlDeviceHeaderSpacing
                Text { text: "OUTPUTS"; color: Theme.textSecondary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.captionSize; font.bold: true }
                Text { text: "Select a device"; color: Theme.textSecondary; font.family: Theme.uiFontFamily; font.pixelSize: Theme.captionSize }
            }

            Column {
                width: parent.width
                spacing: Theme.controlDeviceListSpacing
                Repeater {
                    model: Pipewire.nodes
                    delegate: Rectangle {
                        required property var modelData
                        width: parent.width
                        height: modelData.isSink && !modelData.isStream ? 25 : 0
                        visible: height > 0
                        radius: 6
                            color: modelData === Pipewire.defaultAudioSink ? Theme.selected : "transparent"
                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.controlDeviceInset
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width - 16
                            color: Theme.selectedText
                            font.family: Theme.uiFontFamily
                            font.pixelSize: Theme.captionSize
                            text: modelData.description
                            elide: Text.ElideRight
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData.isSink && !modelData.isStream
                            onClicked: Pipewire.preferredDefaultAudioSink = modelData
                        }
                    }
                }
            }
        }
    }
}