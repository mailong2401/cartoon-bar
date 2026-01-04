// components/ThemeLoader.qml
import QtQuick 2.15

QtObject {
    id: themeLoader

    property string currentTheme: currentConfig.theme
    property var theme: ({})  // theme hiện tại

    signal themeReloaded()     // signal thông báo theme đã thay đổi

    function loadTheme() {
        var filePath = Qt.resolvedUrl("../themes/" + currentTheme + ".json")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", filePath, false)
        xhr.send()

        if (xhr.status === 200) {
            try {
                theme = JSON.parse(xhr.responseText)
            } catch (e) {
                theme = getFallbackTheme()
            }
        } else {
            theme = getFallbackTheme()
        }

        themeReloaded()
        return theme
    }

    function changeTheme(newTheme) {
        currentTheme = newTheme
        return loadTheme()
    }

    function getFallbackTheme() {
        return {
            "primary": { "background": "#ffffff", "foreground": "#000000" },
            "normal": { "black": "#000000", "white": "#ffffff" },
            "cursor": { "cursor": "#000000", "text": "#ffffff" }
        }
    }

    Component.onCompleted: loadTheme()
}

