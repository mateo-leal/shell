import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: root

    property bool ethernetConnected: false
    property string connectionState: "Checking"

    Process {
        id: ethernetQuery
        command: ["nmcli", "-t", "-f", "TYPE,STATE,DEVICE", "device", "status"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const ethernet = this.text.split(/\r?\n/)
                    .map(line => line.split(":"))
                    .find(fields => fields[0] === "ethernet" && fields[1] === "connected")
                root.ethernetConnected = ethernet !== undefined
                root.connectionState = ethernet ? "Connected · " + ethernet[2] : "Disconnected"
            }
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            ethernetQuery.running = true
        }
    }
}