function brewdump -d "Dump a Brewfile to ~/.Brewfile or to a provided path. `brewdump [filepath]`" -a "file"
    if test -n "$file"
        brew bundle dump --force --file "$file"
    else
        brew bundle dump --force --global
    end
end
