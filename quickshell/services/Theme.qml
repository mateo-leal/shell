pragma Singleton

import QtQuick
import "." as ThemeModule

QtObject {
    readonly property QtObject generatedPalette: ThemeModule.ShellPalette {}

    readonly property string uiFontFamily: "FantasqueSansM Nerd Font"
    readonly property string iconFontFamily: "FantasqueSansM Nerd Font Mono"
    readonly property string clockFormat: "ddd d MMM  h:mm AP"

    readonly property int barHeight: 44
    readonly property int barInset: 18
    readonly property int barRightInset: 16
    readonly property int barSpacing: 14
    readonly property int statusSpacing: 11
    readonly property int separatorHeight: 16
    readonly property int iconSize: 24
    readonly property int workspaceDotSize: 7
    readonly property int workspacePillWidth: 22
    readonly property int workspaceMarkerSpacing: 6
    readonly property int workspaceSpecialHeight: 20
    readonly property int workspaceSpecialInset: 7
    readonly property int titleSize: 16
    readonly property int clockSize: 12
    readonly property int bodySize: 12
    readonly property int captionSize: 10
    readonly property int microSize: 9
    readonly property int actionWidth: 30
    readonly property int actionHeight: 28
    readonly property int actionRadius: 8
    readonly property int volumeTextSize: 10
    readonly property int volumeHorizontalInset: 8
    readonly property int islandWidth: 390
    readonly property int islandHeight: 34
    readonly property int islandInset: 13
    readonly property int islandRightInset: 12
    readonly property int islandTextWidthInset: 28
    readonly property int trayIconSize: 18
    readonly property int traySpacing: 8
    readonly property int popoverWidth: 330
    readonly property int popoverRadius: 15
    readonly property int notificationWidth: 340
    readonly property int notificationRadius: 8
    readonly property int popoverTopInset: 50
    readonly property int popoverRightInset: 14
    readonly property int popoverContentInset: 18
    readonly property int notificationContentInset: 17
    readonly property int notificationHeaderSpacing: 10
    readonly property int notificationCardSpacing: 3
    readonly property int islandContentSpacing: 10
    readonly property int islandMetadataSpacing: 1
    readonly property int controlsContentSpacing: 13
    readonly property int controlGridSpacing: 9
    readonly property int controlVolumeSpacing: 9
    readonly property int controlDeviceHeaderSpacing: 8
    readonly property int controlDeviceListSpacing: 4
    readonly property int controlDeviceInset: 8
    readonly property int controlTileHeight: 50
    readonly property int listRowHeight: 25
    readonly property real panelOpacity: 0.92
    readonly property real islandOpacity: 0.94

    readonly property color textPrimary: generatedPalette.surfaceText
    readonly property color textSecondary: generatedPalette.surfaceVariantText
    readonly property color divider: generatedPalette.outlineVariant
    readonly property color outline: generatedPalette.outline
    readonly property color panel: generatedPalette.surface
    readonly property color panelRaised: generatedPalette.surfaceVariant
    readonly property color actionHover: generatedPalette.secondaryContainer
    readonly property color selected: generatedPalette.primaryContainer
    readonly property color selectedText: generatedPalette.primaryContainerText
    readonly property color accent: generatedPalette.primary
    readonly property color accentText: generatedPalette.primaryText
    readonly property color specialWorkspaceColor: generatedPalette.tertiary
    readonly property color specialWorkspaceText: generatedPalette.tertiaryText
    readonly property color error: generatedPalette.errorColor
}