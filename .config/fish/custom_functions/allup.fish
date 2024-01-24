function allup -d "Update all the things"
  echo "Some updates might require sudo!"
  sudo -v

  echo "-- HOMEBREW --"
  brewup

  echo "-- PNPM --"
  pnpmup

  echo "-- PIP --"
  pipup

  echo "-- FISHER --"
  fisherup
end
