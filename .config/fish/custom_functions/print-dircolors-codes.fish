function print-dircolors-codes -d "Print all possible dircolors codes."
    set -l tags

    # add basic codes
    set -l codes \
        "00" "01" "02" "03" "04" "05" "07" "08" \
        "30" "31" "32" "33" "34" "35" "36" "37" \
        "40" "41" "42" "43" "44" "45" "46" "47"

    # add all 256 colors
    for i in (seq 0 255)
        set --append codes "38;5;$i"
    end

    set -l lbCount 0
    for code in $codes
        set --append tags "\e["$code"m"$code"\e[0m"

        set lbCount (math $lbCount + 1)
        if [ $lbCount = 5 ]
            set lbCount 0
            set --append tags "\n"
        end
    end

    echo -e " $tags"
end
