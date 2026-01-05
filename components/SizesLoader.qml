// components/SizesLoader.qml
import QtQuick 2.15

QtObject {
    id: sizesLoader

    property string currentSizeProfile: "1920"  // Mặc định
    property var sizes: ({})  // Tất cả kích thước hiện tại

    signal sizesReloaded()     // Signal thông báo kích thước đã thay đổi

    function loadSizes() {
        var filePath = Qt.resolvedUrl("../themes/sizes/" + currentSizeProfile + ".json")
        var xhr = new XMLHttpRequest()
        xhr.open("GET", filePath, false)
        xhr.send()

        if (xhr.status === 200) {
            try {
                sizes = JSON.parse(xhr.responseText)
            } catch (e) {
                sizes = {}
            }
        } else {
            sizes = {}
        }

        sizesReloaded()
        return sizes
    }

    function changeSizeProfile(newProfile) {
        currentSizeProfile = newProfile
        return loadSizes()
    }

    Component.onCompleted: {
        console.log("SizesLoader initialized with default profile:", currentSizeProfile)
        loadSizes()
    }
}
