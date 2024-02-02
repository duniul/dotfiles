function cleanup-brew -d "Clean up unused Homebrew dependencies and packages"
    set dateSeconds (date +%s)
    set tmpBrewfile "$TMPDIR/Brewfile-$dateSeconds"
    brewdump $tmpBrewfile &>/dev/null
    brew bundle cleanup --file=$tmpBrewfile &>/dev/null
    brew cleanup >/dev/null
    rm -f $tmpBrewfile >/dev/null
end
