function allup -d "Update all the things"
  echo "Some updates might require sudo!"
  sudo -v

  echo "-- HOMEBREW --"
  brewup

  echo "-- FISHER --"
  fisherup

  echo "-- PIP --"
  pipup

  echo "-- PNPM --"
  pnpmup
end
