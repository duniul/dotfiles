function wifi-password -d "Print wifi password (requires keychain authentication)"
    security find-generic-password -wa (wifi-network-name)
end
