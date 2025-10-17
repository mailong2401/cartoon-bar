// components/ThemeLoader.qml
import QtQuick 2.15

QtObject {
    id: themeLoader
    
    property string currentTheme: "light"
    property var themes: {
        "light": {
            "primary": {
                "background": "#f5eee6",
                "foreground": "#2b2530",
                "dim_foreground": "#8c8680",       // thêm
                "bright_foreground": "#2b2530"     // thêm
            },
            "cursor" : {"cursor" : "#2b2530","text": "#f5eee6"},
            "normal": {
                "black": "#5c595e", "red": "#DA103F", "green": "#1EB980",
                "yellow": "#ffc338", "blue": "#67d4f1", "magenta": "#6b28de",
                "cyan": "#2eccca", "white": "#e1e2e7"
            },
            "bright": {
                "black": "#5c595e", "red": "#F43E5C", "green": "#07DA8C",
                "yellow": "#ffcc57", "blue": "#3FC6DE", "magenta": "#7a3fde",
                "cyan": "#1EAEAE", "white": "#e1e2e7"
            }
        },
        "dark" : {
            "primary": {
                "background": "#24273a",
                "foreground": "#cad3f5",
                "dim_foreground": "#8087a2",
                "bright_foreground": "#cad3f5"
            },
            "cursor": {
                "text": "#24273a",
                "cursor": "#f4dbd6"
            },
            "footer_bar": {
                "foreground": "#24273a",
                "background": "#a5adcb"
            },
            "hints": {
                "start": {
                    "foreground": "#24273a",
                    "background": "#eed49f"
                },
                "end": {
                    "foreground": "#24273a",
                    "background": "#a5adcb"
                }
            },
            "selection": {
                "text": "#24273a",
                "background": "#f4dbd6"
            },
            "normal": {
                "black": "#494d64",
                "red": "#ed8796",
                "green": "#a6da95",
                "yellow": "#eed49f",
                "blue": "#8aadf4",
                "magenta": "#f5bde6",
                "cyan": "#8bd5ca",
                "white": "#b8c0e0"
            },
            "bright": {
                "black": "#5b6078",
                "red": "#ed8796",
                "green": "#a6da95",
                "yellow": "#eed49f",
                "blue": "#8aadf4",
                "magenta": "#f5bde6",
                "cyan": "#8bd5ca",
                "white": "#a5adcb"
            },
            "indexed_colors": [
                { "index": 16, "color": "#f5a97f" },
                { "index": 17, "color": "#f4dbd6" }
            ]
        }
    }
    
    function loadTheme(themeName) {
        currentTheme = themeName
        return themes[themeName]
    }
    
    function getCurrentTheme() {
        return themes[currentTheme]
    }
}

