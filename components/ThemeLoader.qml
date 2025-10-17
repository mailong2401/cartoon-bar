// components/ThemeLoader.qml
import QtQuick 2.15

QtObject {
    id: themeLoader
    
    property string currentTheme: "light"
    property var themes: {
        "light": {
            "primary": {
                "background": "#f5eee6",
                "dim_background" : "#E8D8C9",
                "foreground": "#2b2530",
                "dim_foreground": "#8c8680",       // thêm
                "bright_foreground": "#2b2530"     // thêm
              },
            "button" : {
              "background" : "#b0a89e",
              "text" : "#2b2530",
              "background_select" : "#9c8f83",
              "border" : "#4f4f5b",
              "border_select" : "#333",
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
                "dim_background" : "#8087a2",
                "foreground": "#cad3f5",
                "dim_foreground": "#8087a2",
                "bright_foreground": "#cad3f5"
              },
              "button": {
                "background": "#494d64", // normal.black
                "text": "#cad3f5", // primary.foreground
                "background_select": "#5b6078", // bright.black (vì nó sáng hơn normal.black)
                "border": "#b8c0e0", // normal.white
                "border_select": "#a5adcb" // bright.white
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

