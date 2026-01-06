import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "./" as Components

PanelWindow {
    id: detailPanel

    property var sizes: currentSizes.cpuDetailPanel || {}

    implicitWidth: sizes.width || 1030
    implicitHeight: sizes.height || 850

    anchors {
        top: currentConfig.mainPanelPos === "top"
        bottom: currentConfig.mainPanelPos === "bottom"
        left: true
    }

    margins {
        top: currentConfig.mainPanelPos === "top" ? (sizes.marginTop || 10) : 0
        bottom: currentConfig.mainPanelPos === "bottom" ? (sizes.marginBottom || 10) : 0
        left: Math.round((Quickshell.screens.primary?.width ?? currentSizes.name) / 2 - implicitWidth / 2)
    }

    exclusiveZone: 0

    color: "transparent"

    signal closeRequested()

    property int cpuCores: 12
    property var cpuUsageList: Array(cpuCores).fill("0%")
    property var cpuHistory: []
    property int maxHistoryLength: 50
    property var theme: currentTheme

    // Process để lấy CPU usage chi tiết
    Process {
        id: cpuUsageProcess
        command: ["bash", "-c", "mpstat -P ALL 1 1 | tail -n 13 | awk '$2 != \"all\" {printf \"%.1f%%\\n\", 100-$12}'"]
        stdout: StdioCollector {
            onTextChanged: {
                if (this.text) {
                    parseCpuUsageList(this.text)
                }
            }
        }
    }

    function parseCpuUsageList(text) {
        if (!text) return;
        var lines = text.trim().split('\n');
        var cpuListTemp = Array(12).fill("0%")
        var currentUsage = []
        var newHistory = cpuHistory.slice();

        for (var i = 0; i < lines.length && i < cpuCores; i++) {
            var line = lines[i].trim();
            var usage = line.replace(/[^\d.]/g, '');
            if (usage && !isNaN(usage)) {
                cpuListTemp[i] = parseFloat(usage).toFixed(1) + "%";
                currentUsage.push(parseFloat(usage));
            }
        }
        cpuUsageList = cpuListTemp
        
        if (currentUsage.length > 0) {
            newHistory.push({
                timestamp: new Date().getTime(),
                usage: calculateTotalUsageValue(),
                coreUsages: currentUsage
            });
            
            if (newHistory.length > maxHistoryLength) {
                newHistory.shift();
            }
        }
        cpuHistory = newHistory;
    }

    function calculateTotalUsageValue() {
        var total = 0;
        var count = 0;
        for (var i = 0; i < cpuUsageList.length; i++) {
            var usage = parseFloat(cpuUsageList[i]);
            if (!isNaN(usage)) {
                total += usage;
                count++;
            }
        }
        return count > 0 ? total / count : 0;
    }

    function getUsageColor(usageStr) {
        var usage = parseFloat(usageStr);
        if (usage >= 80) return "#e74c3c";
        if (usage >= 60) return "#f39c12";
        if (usage >= 40) return "#f1c40f";
        if (usage >= 20) return "#2ecc71";
        return "#3498db";
    }

    function calculateTotalUsage() {
        return calculateTotalUsageValue().toFixed(1);
    }

    function getMaxUsage() {
        var max = 0;
        for (var i = 0; i < cpuUsageList.length; i++) {
            var usage = parseFloat(cpuUsageList[i]);
            if (!isNaN(usage) && usage > max) {
                max = usage;
            }
        }
        return max.toFixed(1);
    }

    Rectangle {
        anchors.fill: parent
        color: theme.primary.background
        radius: sizes.radius || 8
        border.color: theme.normal.black
        border.width: sizes.borderWidth || 3

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: sizes.margins || 16
            spacing: sizes.spacing || 16

            // Header với nút đóng
            Components.CpuDetailHeader {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.headerHeight || 70
                sizes: detailPanel.sizes
            }

            // Thông tin CPU
            Components.CpuInfoSection {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.infoSectionHeight || 120
                sizes: detailPanel.sizes
            }

            // Hiển thị hình ảnh lõi CPU
            Components.CpuCoresDisplay {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.coresDisplayHeight || 120
                cpuCores: detailPanel.cpuCores
                cpuUsageList: detailPanel.cpuUsageList
                getUsageColor: detailPanel.getUsageColor
                sizes: detailPanel.sizes
            }

            // Thông tin tổng quan
            Components.CpuStatsOverview {
                Layout.fillWidth: true
                Layout.preferredHeight: sizes.statsOverviewHeight || 60
                calculateTotalUsage: detailPanel.calculateTotalUsage
                getMaxUsage: detailPanel.getMaxUsage
                getUsageColor: detailPanel.getUsageColor
                cpuHistory: detailPanel.cpuHistory
                sizes: detailPanel.sizes
            }

            // BIỂU ĐỒ CPU USAGE
            Components.CpuUsageChart {
                Layout.fillWidth: true
                Layout.fillHeight: true
                cpuHistory: detailPanel.cpuHistory
                getUsageColor: detailPanel.getUsageColor
                sizes: detailPanel.sizes
            }
        }
    }

    Timer {
        interval: 2000
        running: detailPanel.visible
        repeat: true
        onTriggered: {
            cpuUsageProcess.running = true;
        }
    }

    Component.onCompleted: {
        if (detailPanel.visible) {
            cpuUsageProcess.running = true;
        }
    }
}
