import QtQuick

Rectangle {
    color: "transparent"
    border.color: "#4f4f5b"
    border.width: 2
    radius: 6

    property var theme
    property var cpuHistory: []
    property var getUsageColor: function(usageStr) { return "#3498db" }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        Row {
            Image{
                width: 40
                height: 40
                source: '../../assets/chart.png'
            }
            Text {
                text: "Biểu Đồ CPU Usage Theo Thời Gian"
                color: "#4f4f5b"
                font.pixelSize: 20
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
            }
        }

        Canvas {
            id: cpuChart
            width: parent.width
            height: parent.height - 30
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                
                if (cpuHistory.length < 2) return;

                var width = cpuChart.width;
                var height = cpuChart.height;
                var padding = 40;
                var chartWidth = width - padding * 2;
                var chartHeight = height - padding * 2;

                ctx.fillStyle = "transparent";
                ctx.fillRect(0, 0, width, height);

                ctx.strokeStyle = "#D4C4B7";
                ctx.lineWidth = 1;
                
                for (var i = 0; i <= 5; i++) {
                    var y = padding + (chartHeight * i / 5);
                    ctx.beginPath();
                    ctx.moveTo(padding, y);
                    ctx.lineTo(width - padding, y);
                    ctx.stroke();
                    
                    ctx.fillStyle = "#4f4f5b";
                    ctx.font = "12px 'ComicShannsMono Nerd Font'";
                    ctx.fillText((100 - i * 20) + "%", 5, y + 4);
                }

                if (cpuHistory.length > 0) {
                    ctx.strokeStyle = "#3498db";
                    ctx.lineWidth = 3;
                    ctx.beginPath();
                    
                    for (var j = 0; j < cpuHistory.length; j++) {
                        var x = padding + (chartWidth * j / (cpuHistory.length - 1));
                        var usage = cpuHistory[j].usage;
                        var y = padding + chartHeight - (chartHeight * usage / 100);
                        
                        if (j === 0) {
                            ctx.moveTo(x, y);
                        } else {
                            ctx.lineTo(x, y);
                        }
                    }
                    ctx.stroke();

                    for (var k = 0; k < cpuHistory.length; k++) {
                        var pointX = padding + (chartWidth * k / (cpuHistory.length - 1));
                        var pointUsage = cpuHistory[k].usage;
                        var pointY = padding + chartHeight - (chartHeight * pointUsage / 100);
                        
                        ctx.fillStyle = getUsageColor(pointUsage.toString());
                        ctx.beginPath();
                        ctx.arc(pointX, pointY, 4, 0, Math.PI * 2);
                        ctx.fill();
                    }

                    if (cpuHistory.length > 0) {
                        var currentUsage = cpuHistory[cpuHistory.length - 1].usage;
                        var currentX = width - padding;
                        var currentY = padding + chartHeight - (chartHeight * currentUsage / 100);
                        
                        ctx.fillStyle = getUsageColor(currentUsage.toString());
                        ctx.font = "14px 'ComicShannsMono Nerd Font'";
                        ctx.fillText(currentUsage.toFixed(1) + "%", currentX + 5, currentY - 5);
                    }
                }

                ctx.strokeStyle = "#4f4f5b";
                ctx.lineWidth = 2;
                ctx.strokeRect(padding, padding, chartWidth, chartHeight);
            }
        }

        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                spacing: 5
                Rectangle {
                    width: 15
                    height: 3
                    color: "#3498db"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "CPU Usage"
                    color: "#4f4f5b"
                    font.pixelSize: 12
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }
    }

    onCpuHistoryChanged: {
        cpuChart.requestPaint();
    }
}
