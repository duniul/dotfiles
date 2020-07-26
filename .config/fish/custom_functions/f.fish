function f -d "Shorthand for `find` in current dir. `f <filename glob>`"
    find . -name $argv[1] 2>&1 | grep -v 'Permission denied'
end
