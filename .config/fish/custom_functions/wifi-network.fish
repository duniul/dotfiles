function wifi-network -d "Print network name of connected wifi network"
    ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'
end
