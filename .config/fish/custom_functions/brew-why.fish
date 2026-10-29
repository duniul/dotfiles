function brew-why -d "Show why a package is installed and what depends on it" -a formula
    set -l dependants (brew uses --installed $argv[1] | jq -Rnc '[inputs]')
    brew info --json=v2 $argv[1] | jq --argjson dependants "$dependants" '.formulae[0] | {
      tap,
      installed_on_request: .installed[0].installed_on_request,
      dependencies,
      dependants: $dependants
  }'
end
