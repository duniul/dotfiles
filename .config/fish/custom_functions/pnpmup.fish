function pnpmup -d "Update global pnpm packages and snapshot the package list"
    corepack pnpm -g update --latest

    set -l list ~/.pnpm/global-packages.txt
    echo "# Global pnpm packages, restored by ~/.dotfiles/setup.sh (`pnpm add -g`)." >$list
    echo "# Snapshot with `pnpmup`, which updates globals and rewrites this file." >>$list
    corepack pnpm -g list --json | jq -r '.[0].dependencies | to_entries[] | "\(.key)@\(.value.version)"' >>$list

    echo -e "\nDone! Global package list updated at:\n  $list"
end
