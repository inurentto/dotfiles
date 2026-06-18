pragma Singleton

import Quickshell
import QtQuick



Singleton {
    id: root

    readonly property int barHeight: 34

    readonly property int notificationWidth: 512

    readonly property var theme: ({
        background0: "base00",
        background1: "base01",
        background2: "base02",

        foreground0: "base06",
        foreground1: "base05",
        foreground2: "base04",

        border: "base03",
        accent: "base07",

        red: "base08",
        orange: "base09",
        yellow: "base0A",
        green: "base0B",
        cyan: "base0C",
        blue: "base0D",
        violet: "base0E",
        pink: "base0F",

        colorScheme: root.colorSchemes.wallust,
        mainFont: "JetBrainsMono Nerd Font Mono",
        iconFont: "JetBrainsMono Nerd Font Propo",

        getBackground0: () => root.theme.colorScheme[root.theme.background0],
        getBackground1: () => root.theme.colorScheme[root.theme.background1],
        getBackground2: () => root.theme.colorScheme[root.theme.background2],

        getForeground0: () => root.theme.colorScheme[root.theme.foreground0],
        getForeground1: () => root.theme.colorScheme[root.theme.foreground1],
        getForeground2: () => root.theme.colorScheme[root.theme.foreground2],

        getBorder: () => root.theme.colorScheme[root.theme.border],
        getAccent: () => root.theme.colorScheme[root.theme.accent],

        getRed: () => root.theme.colorScheme[root.theme.red],
        getOrange: () => root.theme.colorScheme[root.theme.orange],
        getYellow: () => root.theme.colorScheme[root.theme.yellow],
        getGreen: () => root.theme.colorScheme[root.theme.green],
        getCyan: () => root.theme.colorScheme[root.theme.cyan],
        getBlue: () => root.theme.colorScheme[root.theme.blue],
        getViolet: () => root.theme.colorScheme[root.theme.violet],
        getPink: () => root.theme.colorScheme[root.theme.accent],

        easingType: Easing.InOutCubic,

        animationSpeed: {
            ludicrous: 50,
            veryFast: 75,
            fast: 100,
            normal: 250,
            slow: 500
        },
        
        borderWidth: {
            normal: 1
        },

        cornerRadius: {
            small: 4,
            normal: 8,
            big: 16
        },

        padding: {
            small: 4,
            normal: 8,
            big: 16
        },

        spacing: {
            small: 4,
            normal: 8,
            big: 16,
            veryBig: 32
        },

        textSize: {
            smallTitle: 13,
            normal: 11,
            small: 10
        }
    })

    readonly property var colorSchemes: ({
        wallust: {
            base00: "{{background}}",
            base01: "{{background | darken(0.1)}}",
            base02: "{{background | lighten(0.1)}}",
            base03: "{{color8}}",
            base04: "{{foreground | darken(0.2)}}",
            base05: "{{foreground | darken(0.1)}}",
            base06: "{{foreground}}",
            base07: "{{foreground | saturate(0.2)}}",
            base08: "{{color1}}",
            base09: "{{color2}}",
            base0A: "{{color3}}",
            base0B: "{{color4}}",
            base0C: "{{color5}}",
            base0D: "{{color6}}",
            base0E: "{{color7}}",
            base0F: "{{color8}}"
        },

        ayuDark: {
            base00: "#0b0e14",
            base01: "#131721",
            base02: "#202229",
            base03: "#3e4b59",
            base04: "#bfbdb6",
            base05: "#e6e1cf",
            base06: "#ece8db",
            base07: "#f2f0e7",
            base08: "#f07178",
            base09: "#ff8f40",
            base0A: "#ffb454",
            base0B: "#aad94c",
            base0C: "#95e6cb",
            base0D: "#59c2ff",
            base0E: "#d2a6ff",
            base0F: "#e6b450"
        },

        catppuccinMocha: {
            base00: "#1e1e2e",
            base01: "#181825",
            base02: "#313244",
            base03: "#45475a",
            base04: "#585b70",
            base05: "#cdd6f4",
            base06: "#f5e0dc",
            base07: "#b4befe",
            base08: "#f38ba8",
            base09: "#fab387",
            base0A: "#f9e2af",
            base0B: "#a6e3a1",
            base0C: "#94e2d5",
            base0D: "#89b4fa",
            base0E: "#cba6f7",
            base0F: "#f2cdcd"
        }
    })
}