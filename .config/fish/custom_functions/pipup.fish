function pipup -d "Upgrade pipx-managed tools and snapshot the pipx spec"
  echo -e 'Upgrading pipx tools...\n'
  pipx upgrade-all

  set -l spec ~/.config/pipx/pipx-spec.json
  mkdir -p (dirname $spec)
  pipx list --json >$spec
  echo -e "\nDone! pipx spec updated at:\n  $spec"
end
