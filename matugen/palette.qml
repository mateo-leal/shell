import QtQuick

QtObject {
    readonly property string sourceColor: "{{ colors.source_color.default.hex }}"
    readonly property string mode: "{{ mode }}"
    readonly property color primary: "{{ colors.primary.default.hex }}"
    readonly property color primaryText: "{{ colors.on_primary.default.hex }}"
    readonly property color primaryContainer: "{{ colors.primary_container.default.hex }}"
    readonly property color primaryContainerText: "{{ colors.on_primary_container.default.hex }}"
    readonly property color secondary: "{{ colors.secondary.default.hex }}"
    readonly property color secondaryContainer: "{{ colors.secondary_container.default.hex }}"
    readonly property color tertiary: "{{ colors.tertiary.default.hex }}"
    readonly property color background: "{{ colors.background.default.hex }}"
    readonly property color surface: "{{ colors.surface.default.hex }}"
    readonly property color surfaceVariant: "{{ colors.surface_variant.default.hex }}"
    readonly property color surfaceText: "{{ colors.on_surface.default.hex }}"
    readonly property color surfaceVariantText: "{{ colors.on_surface_variant.default.hex }}"
    readonly property color outline: "{{ colors.outline.default.hex }}"
    readonly property color outlineVariant: "{{ colors.outline_variant.default.hex }}"
    readonly property color errorColor: "{{ colors.error.default.hex }}"
    readonly property color errorForeground: "{{ colors.on_error.default.hex }}"
}