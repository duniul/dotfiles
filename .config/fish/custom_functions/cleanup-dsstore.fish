function cleanup-dsstore -d "Recursively delete .DS_Store files"
    gfind . -type f -name '*.DS_Store' -ls -delete
end
