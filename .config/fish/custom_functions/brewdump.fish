function brewdump -d "Dump a Brewfile to ~/.Brewfile or to a provided path. `brewdump [filepath]`" -a "file"
    if test -z "$file"
        set file "$HOME/.Brewfile"
    end

    brew bundle dump --force --file "$file"
    
    # Remove vscode entries from the Brewfile
    sed -i '' '/^vscode/d' "$file"
end
