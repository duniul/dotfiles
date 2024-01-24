function pipup -d "Update pip and it's packages"
  echo 'Updating pip...'
  pip3 install --upgrade pip

  echo 'Updating pip packages...'
  pip3 list --outdated --format=json | jq '.[].name' | xargs -n1 pip3 install -U
end
