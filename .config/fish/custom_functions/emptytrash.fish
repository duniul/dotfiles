function emptytrash -d "Empty the trash on all mounted volumes and main storage, clear Apple's system logs and then clear download history from quarantine."
    sudo rm -rfv /Volumes/*/.Trashes
    sudo rm -rfv /private/var/log/asl/*.asl
    rm -rfv ~/.Trash
    rm -rfv ~/Library/Caches/com.spotify.client/Data
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
end
