import QtQuick

Rectangle {
    property var theme: currentTheme
    property var cpuHistory: []
    property var sizes: currentSizes.cpuDetailPanel
    property var getUsageColor: function(usage) {
        if (usage < 50) return theme.normal.green
        else if (usage < 80) return theme.normal.yellow
        else return theme.normal.red
    }

    color: "transparent"
    border.color: theme.normal.black
    border.width: sizes.chartBorderWidth || 2
    radius: sizes.chartRadius || 6

    Column {
        anchors.fill: parent
        anchors.margins: sizes.chartMargins || 8
        spacing: sizes.chartSpacing || 4

        Row {
            spacing: sizes.chartHeaderSpacing || 8
            Image {
                width: sizes.chartHeaderIconSize || 24
                height: sizes.chartHeaderIconSize || 24
                source: '../../../assets/chart.png'
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "CPU Usage History"
                color: theme.primary.foreground
                font.pixelSize: sizes.chartTitleFontSize || 16
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Canvas {
            id: cpuChart
            width: parent.width
            height: parent.height - 40
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

                // Draw background
                ctx.fillStyle = theme.primary.dim_background;
                ctx.fillRect(padding, padding, chartWidth, chartHeight);

                // Draw grid lines
                ctx.strokeStyle = theme.normal.black;
                ctx.lineWidth = 1;
                ctx.globalAlpha = 0.3;
                
                for (var i = 0; i <= 5; i++) {
                    var y = padding + (chartHeight * i / 5);
                    ctx.beginPath();
                    ctx.moveTo(padding, y);
                    ctx.lineTo(width - padding, y);
                    ctx.stroke();
                    
                    ctx.fillStyle = theme.primary.foreground;
                    ctx.globalAlpha = 0.7;
                    ctx.font = "10px 'ComicShannsMono Nerd Font'";
                    ctx.fillText((100 - i * 20) + "%", 5, y + 4);
                    ctx.globalAlpha = 0.3;
                }

                ctx.globalAlpha = 1.0;

                // Draw CPU usage line
                if (cpuHistory.length > 0) {
                    var gradient = ctx.createLinearGradient(padding, padding, padding, height - padding);
                    gradient.addColorStop(0, theme.normal.blue + "80");
                    gradient.addColorStop(1, theme.normal.blue + "20");
                    
                    // Fill area under line
                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    
                    ctx.moveTo(padding, padding + chartHeight);
                    
                    for (var j = 0; j < cpuHistory.length; j++) {
                        var x = padding + (chartWidth * j / (cpuHistory.length - 1));
                        var usage = cpuHistory[j].usage;
                        var y = padding + chartHeight - (chartHeight * usage / 100);
                        
                        ctx.lineTo(x, y);
                    }
                    
                    ctx.lineTo(width - padding, padding + chartHeight);
                    ctx.closePath();
                    ctx.fill();

                    // Draw line
                    ctx.strokeStyle = theme.normal.blue;
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

                    // Draw points
                    for (var k = 0; k < cpuHistory.length; k++) {
                        var pointX = padding + (chartWidth * k / (cpuHistory.length - 1));
                        var pointUsage = cpuHistory[k].usage;
                        var pointY = padding + chartHeight - (chartHeight * pointUsage / 100);
                        
                        ctx.fillStyle = getUsageColor(pointUsage);
                        ctx.strokeStyle = theme.primary.background;
                        ctx.lineWidth = 2;
                        ctx.beginPath();
                        ctx.arc(pointX, pointY, 5, 0, Math.PI * 2);
                        ctx.fill();
                        ctx.stroke();
                    }

                    // Draw current usage value
                    if (cpuHistory.length > 0) {
                        var currentUsage = cpuHistory[cpuHistory.length - 1].usage;
                        var currentX = width - padding;
                        var currentY = padding + chartHeight - (chartHeight * currentUsage / 100);
                        
                        ctx.fillStyle = getUsageColor(currentUsage);
                        ctx.font = "12px 'ComicShannsMono Nerd Font'";
                        ctx.fillText(currentUsage.toFixed(1) + "%", currentX + 8, currentY - 8);
                    }
                }

                // Draw chart border
                ctx.strokeStyle = theme.normal.black;
                ctx.lineWidth = 2;
                ctx.globalAlpha = 0.5;
                ctx.strokeRect(padding, padding, chartWidth, chartHeight);
                ctx.globalAlpha = 1.0;
            }
        }

        // Legend
        Row {
            spacing: sizes.legendSpacing || 20
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                spacing: sizes.legendItemSpacing || 6
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: sizes.legendIndicatorWidth || 12
                    height: sizes.legendIndicatorHeight || 3
                    color: theme.normal.green
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 1
                }
                Text {
                    text: "Low"
                    color: theme.primary.dim_foreground
                    font.pixelSize: sizes.legendFontSize || 10
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            Row {
                spacing: sizes.legendItemSpacing || 6
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: sizes.legendIndicatorWidth || 12
                    height: sizes.legendIndicatorHeight || 3
                    color: theme.normal.yellow
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 1
                }
                Text {
                    text: "Medium"
                    color: theme.primary.dim_foreground
                    font.pixelSize: sizes.legendFontSize || 10
                    font.family: "ComicShannsMono Nerd Font"
                }
            }

            Row {
                spacing: sizes.legendItemSpacing || 6
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: sizes.legendIndicatorWidth || 12
                    height: sizes.legendIndicatorHeight || 3
                    color: theme.normal.red
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 1
                }
                Text {
                    text: "High"
                    color: theme.primary.dim_foreground
                    font.pixelSize: sizes.legendFontSize || 10
                    font.family: "ComicShannsMono Nerd Font"
                }
            }
        }
    }

    onCpuHistoryChanged: {
        cpuChart.requestPaint();
    }
}
