function cleanup-ls -d "Clean up LaunchServices to remove duplicates in the “Open With” menu"
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
end
