function print-colors -a "dircolorsFile" -d "Print LS_COLORS, listing types and extensions in their assigned color. Uses current LS_COLORS by default, but also accepts a .dircolors file."
    set originalLsColors $LS_COLORS

	# temporarily set LS_COLORS if .dircolors file is provided
    if test -n "$dircolorsFile"
        eval (dircolors-fish $dircolorsFile)
    end

    set spaceSeparatedLsColors (string split ':' $LS_COLORS)
    set tags

    echo $lsColors

    for lsColor in $spaceSeparatedLsColors
        set -l colorTuple (string split '=' $lsColor)
        set -l typeOrExt $colorTuple[1]
        set -l color $colorTuple[2]

        # colorize if it's a valid color
        if test (string match -r "^[0-9\;]+\$" $color)
            set --append tags "\e["$color"m"$typeOrExt"\e[0m"
        else
            set --append tags $typeOrExt
        end
    end

    # reset LS_COLORS
    set -x LS_COLORS $originalLsColors
    echo -e $tags
end

alias print_lscolors="print_colors"
alias print_dircolors="print_colors"
