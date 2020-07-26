function cleanup-dsstore -d "Recursively delete .DS_Store files"
    find . -type f -name '*.DS_Store' -ls -delete
end
