function brewup -d "Update brew, upgrade brew installs, cleanup and run doctor"
    brew -v update
    brew upgrade -v --force-bottle
    cleanup_brew
    brew doctor
    cask doctor
end
