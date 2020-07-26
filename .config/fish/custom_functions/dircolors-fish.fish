function dircolors-fish -d "Sets LS_COLORS properly for fish shell"
    # store dircolors result for C shell, which uses 'setenv'
    set dircolorsCResult (gdircolors -c $argv)

    # replace 'setenv' with 'set -x'
    set dircolorsFishResult (string replace "setenv" "set -x" $dircolorsCResult)
    echo $dircolorsFishResult
end
