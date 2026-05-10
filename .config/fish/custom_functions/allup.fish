function allup -d "Update all the things"
  echo "Some updates might require sudo!"
  sudo -v

  echo -e "\n-- HOMEBREW --"
  brewup

  echo -e "\n-- FISHER --"
  fisherup

  echo -e "\n-- PIPX --"
  pipup

  echo -e "\n-- PNPM --"
  pnpmup

  echo -e "\n-- RUST --"
  rustup update
end
