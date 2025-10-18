#!/usr/bin/env python3
import json
import subprocess
import sys

class WiFiManager:
    def __init__(self):
        self.connected_ssid = None
    
    def get_wifi_networks(self, rescan=True):
        """Lấy danh sách WiFi networks và lọc trùng"""
        try:
            cmd = [
                'nmcli', '-t', '-f', 
                'SSID,SIGNAL,SECURITY,ACTIVE,IN-USE,BSSID', 
                'dev', 'wifi', 'list'
            ]
            
            if rescan:
                cmd.extend(['--rescan', 'yes'])
            
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            
            if result.returncode != 0:
                return {"error": f"nmcli failed: {result.stderr}"}
            
            wifi_networks = []
            seen_networks = set()
            self.connected_ssid = None
            
            for line in result.stdout.strip().split('\n'):
                if not line:
                    continue
                    
                parts = line.split(':')
                if len(parts) >= 6:
                    ssid, signal, security, active, in_use, bssid = parts[:6]
                    
                    # Xử lý SSID và BSSID
                    ssid = ssid.replace('\\:', ':') if ssid else "[Hidden]"
                    bssid = bssid.rstrip('\\')
                    
                    # Tạo key duy nhất và kiểm tra trùng lặp
                    network_key = f"{ssid}_{bssid}"
                    if network_key not in seen_networks:
                        seen_networks.add(network_key)
                        
                        network = {
                            "ssid": ssid,
                            "signal_strength": int(signal),
                            "security": security,
                            "is_active": (active == "yes"),
                            "is_connected": (in_use == "*"),
                            "bssid": bssid,
                            "signal_level": self.get_signal_level(int(signal))
                        }
                        
                        if network["is_connected"]:
                            self.connected_ssid = ssid
                        
                        wifi_networks.append(network)
            
            # Loại bỏ SSID trùng và sắp xếp
            wifi_networks = self.remove_duplicate_ssids(wifi_networks)
            
            return {
                "success": True,
                "count": len(wifi_networks),
                "connected_ssid": self.connected_ssid,
                "networks": wifi_networks
            }
            
        except subprocess.TimeoutExpired:
            return {"error": "Scan timeout"}
        except Exception as e:
            return {"error": f"Unexpected error: {str(e)}"}
    
    def remove_duplicate_ssids(self, networks):
        """Loại bỏ các SSID trùng lặp, giữ lại bản có signal mạnh nhất"""
        unique_networks = {}
        
        for network in networks:
            ssid = network["ssid"]
            if ssid not in unique_networks or network["signal_strength"] > unique_networks[ssid]["signal_strength"]:
                unique_networks[ssid] = network
        
        # Sắp xếp theo signal strength giảm dần
        return sorted(unique_networks.values(), key=lambda x: x["signal_strength"], reverse=True)
    
    def get_signal_level(self, signal_strength):
        """Phân loại mức độ tín hiệu"""
        if signal_strength >= 80:
            return "excellent"
        elif signal_strength >= 60:
            return "good"
        elif signal_strength >= 40:
            return "fair"
        elif signal_strength >= 20:
            return "poor"
        else:
            return "very_poor"

def main():
    wifi_manager = WiFiManager()
    
    # Chỉ hỗ trợ scan WiFi với lọc trùng
    result = wifi_manager.get_wifi_networks()
    print(json.dumps(result, indent=2, ensure_ascii=False))

if __name__ == "__main__":
    main()
