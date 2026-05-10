function brewup -d "Update brew, upgrade brew installs, cleanup and run doctor"
    sudo -v

    echo "Updating Homebrew"
    brew -v update
    
    echo "Upgrading Homebrew installs..."
    brew upgrade -v

    echo "Running Homebrew doctor..."
    brew doctor --verbose

    echo "Updating .Brewfile..."
    brewdump
end
