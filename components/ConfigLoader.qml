// components/ConfigLoader.qml
import QtQuick 2.15

QtObject {
    id: configLoader

    property string currentConfigProfile: "default"
    property var config: ({})  // Tất cả cấu hình hiện tại

    signal configReloaded()     // Signal thông báo cấu hình đã thay đổi

    function loadConfig() {
        var filePath = Qt.resolvedUrl("../configs/" + currentConfigProfile + ".json")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", filePath, false)
        xhr.send()

        if (xhr.status === 200) {
            try {
                config = JSON.parse(xhr.responseText)
            } catch (e) {
                config = {}
            }
        } else {
            config = {}
        }

        configReloaded()
        return config
    }

    function changeConfigProfile(newProfile) {
        currentConfigProfile = newProfile
        return loadConfig()
    }

    Component.onCompleted: loadConfig()
}
