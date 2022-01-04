function voltup -d "Update all global packages installed with Volta to the latest version."
    set -l packagesPath "$HOME/.volta/tools/user/packages"
    set -l voltaFiles (ls $packagesPath)

    echo -e "Updating all global packages installed with Volta...\n"

    for file in $voltaFiles
        set -l packagePath "$packagesPath/$file"
        set -l name (jq -r '.name' $packagePath)

        volta install $name
    end

    echo "Done, all global packages have been updated!"
end
