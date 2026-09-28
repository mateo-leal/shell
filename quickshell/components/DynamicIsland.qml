import Quickshell.Services.Mpris
import QtQuick
import "../services"

Item {
    id: root

    property bool volumePulse: false
    property bool notificationPulse: false
    property var latestNotification: null
    width: Theme.islandWidth
    height: Theme.islandHeight

    Rectangle {
        anchors.fill: parent
        topLeftRadius: 0
        topRightRadius: 0
        radius: height / 2
        color: Theme.panel
        opacity: Theme.islandOpacity
        border.color: Theme.divider
        border.width: 1
    }

    Text {
        anchors.centerIn: parent
        visible: root.volumePulse
        color: Theme.textPrimary
        font.family: Theme.uiFontFamily
        font.pixelSize: Theme.bodySize
        font.bold: true
        text: "VOLUME CHANGED"
    }

    Text {
        anchors.centerIn: parent
        visible: !root.volumePulse && root.notificationPulse && root.latestNotification !== null
        width: parent.width - Theme.islandTextWidthInset
        color: Theme.textPrimary
        font.family: Theme.uiFontFamily
        font.pixelSize: Theme.bodySize
        font.bold: true
        text: root.latestNotification ? root.latestNotification.summary : ""
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        anchors.centerIn: parent
        visible: !root.volumePulse && !root.notificationPulse && Mpris.players.count === 0
        color: Theme.textSecondary
        font.family: Theme.uiFontFamily
        font.pixelSize: Theme.bodySize
        text: "No media playing"
    }

    Repeater {
        model: Mpris.players

        delegate: Row {
            required property var modelData
            required property int index

            anchors.fill: parent
            anchors.leftMargin: Theme.islandInset
            anchors.rightMargin: Theme.islandRightInset
            spacing: Theme.islandContentSpacing
            visible: index === 0 && !root.volumePulse && !root.notificationPulse

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.isPlaying ? "PLAYING" : "PAUSED"
                color: Theme.textSecondary
                font.family: Theme.uiFontFamily
                font.pixelSize: Theme.microSize
                font.bold: true
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: Math.max(100, parent.width - 158)
                spacing: Theme.islandMetadataSpacing

                Text {
                    width: parent.width
                    text: modelData.trackTitle || modelData.identity
                    color: Theme.textPrimary
                    font.family: Theme.uiFontFamily
                    font.pixelSize: Theme.bodySize
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: modelData.trackArtist || modelData.trackAlbum || "Media player"
                    color: Theme.textSecondary
                    font.family: Theme.uiFontFamily
                    font.pixelSize: Theme.microSize
                    elide: Text.ElideRight
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: modelData.isPlaying ? "" : ""
                color: Theme.textPrimary
                font.family: Theme.iconFontFamily
                font.pixelSize: Theme.iconSize
                MouseArea {
                    anchors.fill: parent
                    onClicked: modelData.togglePlaying()
                }
            }
        }
    }
}