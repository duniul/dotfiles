function gz -d "Print original and gzipped size"
    printf "%-20s %12s\n" "compression method" "bytes"
    printf "%-20s %'12.0f\n" "original" (cat "$argv[1]" | wc -c)
    printf "%-20s %'12.0f\n" "gzipped (-5)" (cat "$argv[1]" | gzip -5 -c | wc -c)
    printf "%-20s %'12.0f\n" "gzipped (--best)" (cat "$argv[1]" | gzip --best -c | wc -c)
end
