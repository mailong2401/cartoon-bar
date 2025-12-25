// components/Settings/NetworkSettings.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var theme : currentTheme
    
    ScrollView {
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        
        ColumnLayout {
            width: 470
            spacing: 20
            
            Text {
                text: "Network Settings"
                color: theme.primary.foreground
                font.pixelSize: 24
                font.bold: true
                font.family: "ComicShannsMono Nerd Font"
                Layout.topMargin: 10
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.primary.dim_foreground + "40"
            }
            
            // 1️⃣ Thông tin cơ bản
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: basicInfoLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: basicInfoLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Network Interface Information"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 10
                        Layout.fillWidth: true
                        
                        // Interface Name
                        Text {
                            text: "Interface:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "wlp2s0"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            font.bold: true
                        }
                        
                        // Connection Status
                        Text {
                            text: "Status:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                color: theme.normal.green
                            }
                            Text {
                                text: "Connected"
                                color: theme.normal.green
                                font.pixelSize: 14
                                font.family: "ComicShannsMono Nerd Font"
                                font.bold: true
                            }
                        }
                        
                        // Connection Type
                        Text {
                            text: "Type:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "Wireless"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // IP Address
                        Text {
                            text: "IP Address:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "192.168.1.105"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // Subnet Mask
                        Text {
                            text: "Subnet Mask:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "255.255.255.0"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // Gateway
                        Text {
                            text: "Gateway:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "192.168.1.1"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // DNS Server
                        Text {
                            text: "DNS Server:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "192.168.1.1, 8.8.8.8"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // MAC Address
                        Text {
                            text: "MAC Address:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "a4:5e:60:cd:35:8a"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        // Signal Strength
                        Text {
                            text: "Signal Strength:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        RowLayout {
                            spacing: 10
                            Rectangle {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 6
                                radius: 3
                                color: theme.primary.dim_foreground + "40"
                                
                                Rectangle {
                                    width: parent.width * 0.85
                                    height: parent.height
                                    radius: 3
                                    color: theme.normal.green
                                }
                            }
                            Text {
                                text: "85%"
                                color: theme.primary.foreground
                                font.pixelSize: 12
                                font.family: "ComicShannsMono Nerd Font"
                            }
                        }
                    }
                }
            }
            
            // 2️⃣ Wi-Fi Settings
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: wifiLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: wifiLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Wi-Fi Networks"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    // Current connected network
                    Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        radius: 6
                        color: theme.normal.blue + "10"
                        border.color: theme.normal.blue
                        border.width: 2
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 15
                            
                            Text {
                                text: "📶"
                                font.pixelSize: 20
                            }
                            
                            ColumnLayout {
                                spacing: 2
                                Layout.fillWidth: true
                                
                                Text {
                                    text: "Home-WiFi-5G"
                                    color: theme.primary.foreground
                                    font.pixelSize: 14
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.bold: true
                                }
                                
                                Text {
                                    text: "Connected • 5 GHz • WPA2"
                                    color: theme.primary.dim_foreground
                                    font.pixelSize: 11
                                    font.family: "ComicShannsMono Nerd Font"
                                }
                            }
                            
                            Button {
                                text: "Disconnect"
                                font.family: "ComicShannsMono Nerd Font"
                                font.pixelSize: 11
                                Layout.preferredWidth: 100
                                
                                background: Rectangle {
                                    radius: 4
                                    color: parent.down ? theme.normal.red : 
                                           parent.hovered ? theme.normal.red + "40" : theme.button.background
                                    border.color: theme.normal.red
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    color: theme.normal.red
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font: parent.font
                                }
                            }
                        }
                    }
                    
                    // Available networks
                    Repeater {
                        model: [
                            { name: "Office-Guest", strength: 70, security: "WPA2", connected: false },
                            { name: "Cafe-Free-WiFi", strength: 60, security: "Open", connected: false },
                            { name: "Neighbor-2.4G", strength: 45, security: "WPA2", connected: false }
                        ]
                        
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 50
                            radius: 6
                            color: wifiMouseArea.containsMouse ? theme.button.background + "40" : "transparent"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15
                                
                                // Signal strength indicator
                                ColumnLayout {
                                    spacing: 2
                                    Layout.preferredWidth: 60
                                    
                                    RowLayout {
                                        spacing: 2
                                        Repeater {
                                            model: 4
                                            Rectangle {
                                                Layout.preferredWidth: 3
                                                Layout.preferredHeight: 4 + index * 3
                                                color: index < (modelData.strength / 25) ? theme.normal.blue : theme.primary.dim_foreground + "40"
                                                radius: 1
                                            }
                                        }
                                    }
                                    
                                    Text {
                                        text: modelData.strength + "%"
                                        color: theme.primary.dim_foreground
                                        font.pixelSize: 9
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                }
                                
                                ColumnLayout {
                                    spacing: 2
                                    Layout.fillWidth: true
                                    
                                    Text {
                                        text: modelData.name
                                        color: theme.primary.foreground
                                        font.pixelSize: 14
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                    
                                    Text {
                                        text: modelData.security
                                        color: theme.primary.dim_foreground
                                        font.pixelSize: 11
                                        font.family: "ComicShannsMono Nerd Font"
                                    }
                                }
                                
                                Button {
                                    text: "Connect"
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 80
                                    
                                    background: Rectangle {
                                        radius: 4
                                        color: parent.down ? theme.normal.blue : 
                                               parent.hovered ? theme.normal.blue + "40" : theme.button.background
                                        border.color: theme.normal.blue
                                        border.width: 1
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: theme.normal.blue
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font: parent.font
                                    }
                                }
                            }
                            
                            MouseArea {
                                id: wifiMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: console.log("Selected network:", modelData.name)
                            }
                        }
                    }
                    
                    RowLayout {
                        spacing: 10
                        
                        Button {
                            text: "🔄 Scan Networks"
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            background: Rectangle {
                                radius: 4
                                color: parent.down ? theme.button.background_select : 
                                       parent.hovered ? theme.button.background + "40" : theme.button.background
                                border.color: theme.button.border
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                color: theme.primary.foreground
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font: parent.font
                            }
                        }
                        
                        CheckBox {
                            id: autoConnect
                            text: "Auto connect"
                            checked: true
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                border.color: theme.button.border
                                border.width: 1
                                color: theme.button.background
                                
                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 2
                                    color: theme.normal.blue
                                    visible: autoConnect.checked
                                    anchors.centerIn: parent
                                }
                            }
                            
                            contentItem: Text {
                                text: autoConnect.text
                                font: autoConnect.font
                                color: theme.primary.foreground
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: autoConnect.indicator.width + autoConnect.spacing
                            }
                        }
                    }
                }
            }
            
            // 3️⃣ Wired Settings
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: wiredLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: wiredLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Wired Connection"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    RowLayout {
                        spacing: 15
                        
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: theme.normal.blue + "20"
                            border.color: theme.normal.blue
                            border.width: 2
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🔌"
                                font.pixelSize: 18
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 2
                            Layout.fillWidth: true
                            
                            Text {
                                text: "Ethernet (eth0)"
                                color: theme.primary.foreground
                                font.pixelSize: 14
                                font.family: "ComicShannsMono Nerd Font"
                                font.bold: true
                            }
                            
                            Text {
                                text: "Disconnected • Cable unplugged"
                                color: theme.primary.dim_foreground
                                font.pixelSize: 11
                                font.family: "ComicShannsMono Nerd Font"
                            }
                        }
                    }
                    
                    ComboBox {
                        id: ipConfigCombo
                        model: ["DHCP (Automatic)", "Manual (Static IP)"]
                        currentIndex: 0
                        Layout.fillWidth: true
                        
                        background: Rectangle {
                            radius: 4
                            color: theme.button.background
                            border.color: theme.button.border
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: ipConfigCombo.displayText
                            color: theme.primary.foreground
                            font.pixelSize: 12
                            font.family: "ComicShannsMono Nerd Font"
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 10
                        }
                    }
                }
            }
            
            // 4️⃣ VPN Settings
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: vpnLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: vpnLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "VPN Connections"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    Repeater {
                        model: [
                            { name: "Work VPN", connected: false },
                            { name: "Personal VPN", connected: true },
                            { name: "Server VPN", connected: false }
                        ]
                        
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            height: 50
                            radius: 6
                            color: vpnMouseArea.containsMouse ? theme.button.background + "40" : "transparent"
                            border.color: modelData.connected ? theme.normal.green : "transparent"
                            border.width: 2
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15
                                
                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 15
                                    color: theme.normal.blue + "20"
                                    border.color: theme.normal.blue
                                    border.width: 1
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "🔒"
                                        font.pixelSize: 14
                                    }
                                }
                                
                                Text {
                                    text: modelData.name
                                    color: theme.primary.foreground
                                    font.pixelSize: 14
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.bold: modelData.connected
                                    Layout.fillWidth: true
                                }
                                
                                Button {
                                    text: modelData.connected ? "Disconnect" : "Connect"
                                    font.family: "ComicShannsMono Nerd Font"
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 90
                                    
                                    background: Rectangle {
                                        radius: 4
                                        color: parent.down ? 
                                               (modelData.connected ? theme.normal.red : theme.normal.green) : 
                                               parent.hovered ? 
                                               (modelData.connected ? theme.normal.red + "40" : theme.normal.green + "40") : 
                                               theme.button.background
                                        border.color: modelData.connected ? theme.normal.red : theme.normal.green
                                        border.width: 1
                                    }
                                    
                                    contentItem: Text {
                                        text: parent.text
                                        color: modelData.connected ? theme.normal.red : theme.normal.green
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        font: parent.font
                                    }
                                }
                            }
                            
                            MouseArea {
                                id: vpnMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                    
                    Button {
                        text: "+ Add VPN Configuration"
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignHCenter
                        
                        background: Rectangle {
                            radius: 4
                            color: parent.down ? theme.normal.blue : 
                                   parent.hovered ? theme.normal.blue + "40" : theme.button.background
                            border.color: theme.normal.blue
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: theme.normal.blue
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                    }
                }
            }
            
            // 5️⃣ Advanced Settings
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: advancedLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: advancedLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Advanced Settings"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        Layout.fillWidth: true
                        
                        Text {
                            text: "DNS Servers:"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        ComboBox {
                            id: dnsCombo
                            model: ["Automatic", "Google (8.8.8.8)", "Cloudflare (1.1.1.1)", "OpenDNS", "Custom"]
                            currentIndex: 0
                            Layout.fillWidth: true
                            
                            background: Rectangle {
                                radius: 4
                                color: theme.button.background
                                border.color: theme.button.border
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: dnsCombo.displayText
                                color: theme.primary.foreground
                                font.pixelSize: 12
                                font.family: "ComicShannsMono Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                        }
                        
                        Text {
                            text: "Hostname:"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        TextField {
                            text: "quick-shell-pc"
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            Layout.fillWidth: true
                            
                            background: Rectangle {
                                radius: 4
                                color: theme.button.background
                                border.color: theme.button.border
                                border.width: 1
                            }
                        }
                        
                        Text {
                            text: "Proxy Settings:"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        ComboBox {
                            id: proxyCombo
                            model: ["No Proxy", "Manual Proxy", "Auto-detect"]
                            currentIndex: 0
                            Layout.fillWidth: true
                            
                            background: Rectangle {
                                radius: 4
                                color: theme.button.background
                                border.color: theme.button.border
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: proxyCombo.displayText
                                color: theme.primary.foreground
                                font.pixelSize: 12
                                font.family: "ComicShannsMono Nerd Font"
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                            }
                        }
                    }
                    
                    RowLayout {
                        spacing: 20
                        
                        CheckBox {
                            id: autoStartNetwork
                            text: "Auto-start network on boot"
                            checked: true
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                border.color: theme.button.border
                                border.width: 1
                                color: theme.button.background
                                
                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 2
                                    color: theme.normal.blue
                                    visible: autoStartNetwork.checked
                                    anchors.centerIn: parent
                                }
                            }
                            
                            contentItem: Text {
                                text: autoStartNetwork.text
                                font: autoStartNetwork.font
                                color: theme.primary.foreground
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: autoStartNetwork.indicator.width + autoStartNetwork.spacing
                            }
                        }
                        
                        CheckBox {
                            id: bandwidthMonitor
                            text: "Enable bandwidth monitoring"
                            checked: true
                            font.family: "ComicShannsMono Nerd Font"
                            font.pixelSize: 12
                            
                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                border.color: theme.button.border
                                border.width: 1
                                color: theme.button.background
                                
                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 2
                                    color: theme.normal.blue
                                    visible: bandwidthMonitor.checked
                                    anchors.centerIn: parent
                                }
                            }
                            
                            contentItem: Text {
                                text: bandwidthMonitor.text
                                font: bandwidthMonitor.font
                                color: theme.primary.foreground
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: bandwidthMonitor.indicator.width + bandwidthMonitor.spacing
                            }
                        }
                    }
                }
            }
            
            // 6️⃣ Network Statistics
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: statsLayout.height + 30
                radius: 8
                color: theme.primary.background
                border.color: theme.normal.black
                border.width: 1
                
                ColumnLayout {
                    id: statsLayout
                    width: parent.width
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    spacing: 15
                    
                    Text {
                        text: "Network Statistics"
                        color: theme.primary.foreground
                        font.pixelSize: 18
                        font.bold: true
                        font.family: "ComicShannsMono Nerd Font"
                    }
                    
                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 10
                        Layout.fillWidth: true
                        
                        Text {
                            text: "Download Speed:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "2.4 MB/s"
                            color: theme.normal.green
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            font.bold: true
                        }
                        
                        Text {
                            text: "Upload Speed:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "0.8 MB/s"
                            color: theme.normal.blue
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                            font.bold: true
                        }
                        
                        Text {
                            text: "Public IP:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "203.0.113.45"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        Text {
                            text: "Ping to Gateway:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        RowLayout {
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: theme.normal.blue
                            }
                            Text {
                                text: "3.2 ms"
                                color: theme.normal.green
                                font.pixelSize: 14
                                font.family: "ComicShannsMono Nerd Font"
                                font.bold: true
                            }
                        }
                        
                        Text {
                            text: "Data Received:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "1.2 GB"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        
                        Text {
                            text: "Data Sent:"
                            color: theme.primary.dim_foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                        Text {
                            text: "345 MB"
                            color: theme.primary.foreground
                            font.pixelSize: 14
                            font.family: "ComicShannsMono Nerd Font"
                        }
                    }
                    
                    Button {
                        text: "🔄 Refresh Statistics"
                        font.family: "ComicShannsMono Nerd Font"
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignHCenter
                        
                        background: Rectangle {
                            radius: 4
                            color: parent.down ? theme.button.background_select : 
                                   parent.hovered ? theme.button.background + "40" : theme.button.background
                            border.color: theme.button.border
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: theme.primary.foreground
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font: parent.font
                        }
                    }
                }
            }
        }
    }
}
