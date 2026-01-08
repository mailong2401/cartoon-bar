import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Column {
    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel


    spacing: sizes.infoSpacing || 6

    // CPU Info properties
    property string cpuName: lang.infoSection.loading
    property string cpuVendor: lang.infoSection.loading
    property string cpuArch: lang.infoSection.loading
    property string cpuSocket: lang.infoSection.loading
    property var lang : currentLanguage
    property bool infoLoaded: false

    // Process để lấy thông tin CPU
    Process {
        id: cpuInfoProcess
        running: false
        command: ["bash", "-c", "lscpu | grep -E 'Model name|Vendor ID|Architecture|Socket'"]

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text && !infoLoaded) {
                    parseCpuInfo(this.text);
                    infoLoaded = true;
                }
            }
        }
    }

    // Chạy một lần khi component được tạo
    Component.onCompleted: {
        if (!infoLoaded) {
            cpuInfoProcess.running = true;
        }
    }

    // Parse thông tin từ lscpu output
    function parseCpuInfo(output) {
        var lines = output.split('\n');
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();

            if (line.indexOf('Architecture:') !== -1) {
                cpuArch = line.split(':')[1].trim();
            } else if (line.indexOf('Vendor ID:') !== -1) {
                cpuVendor = line.split(':')[1].trim();
            } else if (line.indexOf('Model name:') !== -1) {
                cpuName = line.split(':')[1].trim();
            } else if (line.indexOf('Socket(s):') !== -1) {
                cpuSocket = line.split(':')[1].trim();
            }
        }
    }
    
    // Hiển thị thông tin CPU
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: lang.infoSection.name + ": " + cpuName
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: lang.infoSection.vendor + ": " + cpuVendor
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: lang.infoSection.architecture + ": " + cpuArch
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: lang.infoSection.socket + ": " + cpuSocket
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
}
