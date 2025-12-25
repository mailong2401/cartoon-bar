// components/LanguageLoader.qml
import QtQuick 2.15

QtObject {
    id: languageLoader

    // --- Thuộc tính ---
    property string currentLanguage: "vi"
    property var translations: ({})  // Dữ liệu ngôn ngữ hiện tại

    // --- Tín hiệu ---
    signal languageChanged(string lang)  // Phát ra khi đổi ngôn ngữ

    // --- Hàm tải ngôn ngữ ---
    function loadLanguage() {
        var filePath = Qt.resolvedUrl("../languages/" + currentLanguage + ".json")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", filePath, false)  // đồng bộ như ThemeLoader
        xhr.send()

        if (xhr.status === 200) {
            try {
                translations = JSON.parse(xhr.responseText)
            } catch (e) {
                translations = getFallbackLanguage()
            }
        } else {
            translations = getFallbackLanguage()
        }

        // 🧠 Phát tín hiệu sau khi load thành công
        languageChanged(currentLanguage)

        return translations
    }

    // --- Đổi ngôn ngữ ---
    function changeLanguage(newLang) {
        currentLanguage = newLang
        return loadLanguage()
    }

    // --- Ngôn ngữ dự phòng ---
    function getFallbackLanguage() {
        return {
            "settings": {
                "title": "Settings",
                "general": "General",
                "appearance": "Appearance",
                "network": "Network",
                "audio": "Audio",
                "performance": "Performance",
                "shortcuts": "Shortcuts",
                "system": "System"
            }
        }
    }

    // --- Hàm tiện ích lấy chuỗi dịch ---
    function t(section, key) {
        if (translations[section] && translations[section][key])
            return translations[section][key]
        return key // fallback nếu chưa dịch
    }

    // --- Tự load khi khởi động ---
    Component.onCompleted: loadLanguage()
}

