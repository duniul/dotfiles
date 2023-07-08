function brewup -d "Update brew, upgrade brew installs, cleanup and run doctor"
    echo "Some updates might require sudo!"
    sudo -v

    echo "Updating Homebrew"
    brew -v update
    
    echo "Upgrading Homebrew installs..."
    brew upgrade
    brew upgrade -v --force-bottle

    echo "Cleaning up Homebrew installs..."
    cleanup-brew

    echo "Running Homebrew doctor..."
    brew doctor --verbose
end
