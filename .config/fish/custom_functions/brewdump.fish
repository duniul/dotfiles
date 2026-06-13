function brewdump -d "Dump a Brewfile to ~/.Brewfile or to a provided path. `brewdump [filepath]`" -a file
    if test -z "$file"
        set file "$HOME/.Brewfile"
    end

    brew bundle dump --file "$file" --force --tap --brew --cask --no-describe

    sed -i '' 's/\(brew "docker"\), link: false/\1/' "$file" # strip link: false only from the docker line
end
