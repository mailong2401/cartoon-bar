import QtQuick
import QtQuick.Controls

Column {
    property var theme: currentTheme
    property var sizes: currentSizes.cpuDetailPanel
    
    spacing: sizes.infoSpacing || 6
    
    // CPU Info properties
    property string cpuName: "Đang tải..."
    property string cpuVendor: "Đang tải..."
    property string cpuArch: "Đang tải..."
    property string cpuSocket: "Đang tải..."
    
    // Chạy một lần khi component được tạo
    Component.onCompleted: {
        // Sử dụng Qt.callLater để không block UI
        Qt.callLater(function() {
            // Đọc từ file cache hoặc chạy lệnh
            var info = getCpuInfoFromSystem();
            if (info) {
                cpuName = info.modelName || "Không xác định";
                cpuVendor = info.vendor || "Không xác định";
                cpuArch = info.architecture || "Không xác định";
                cpuSocket = info.socket || "Không xác định";
            }
        });
    }
    
    // Hàm giả lập để lấy thông tin CPU
    function getCpuInfoFromSystem() {
        // Trong thực tế, bạn cần integrate với C++ backend
        // Hoặc sử dụng QProcess từ QtCore
        return {
            modelName: "Intel(R) Core(TM) i5-1035G1 CPU @ 1.00GHz",
            vendor: "GenuineIntel",
            architecture: "x86_64",
            socket: "1"
        };
    }
    
    // Hiển thị thông tin CPU
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Tên: " + cpuName
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Nhà cung cấp: " + cpuVendor
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Kiến trúc: " + cpuArch
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
    
    Text {
        width: parent.width
        color: theme.primary.foreground
        text: "Số socket: " + cpuSocket
        font.pixelSize: sizes.infoFontSize || 18
        font.family: "ComicShannsMono Nerd Font"
    }
}