function wifi-reset -d "Turn wifi connection on and off."
    networksetup -setairportpower en0 off
    networksetup -setairportpower en0 on
end
