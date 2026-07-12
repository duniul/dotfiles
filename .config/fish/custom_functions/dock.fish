function dock -d "Save or restore the macOS Dock configuration. `dock save|restore`" -a action
    set -l file "$HOME/.dotfiles/dock/com.apple.dock.plist"

    switch "$action"
        case save
            mkdir -p (dirname "$file")
            defaults export com.apple.dock - >"$file"
            echo "Dock configuration saved to:"
            echo "  $file"
        case restore
            if not test -f "$file"
                echo "No saved Dock configuration found at:" >&2
                echo "  $file" >&2
                return 1
            end
            defaults import com.apple.dock "$file"
            killall Dock
            echo "Dock configuration restored from:"
            echo "  $file"
        case '*'
            echo "Usage: dock save|restore" >&2
            return 1
    end
end
