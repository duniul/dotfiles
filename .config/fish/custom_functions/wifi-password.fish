function wifi-password -d "Print wifi password (requires keychain authentication)"
    security find-generic-password -a (wifi-network) -s "AirPort" -w
end
