function fisherup -d "Update all fisher packages"
  echo 'Updating fisher...'
  fisher update

  # Drop stale fish-async-prompt backups so its re-registered setup handler can 
  # re-create them on the next prompt without errors.
  for func in (functions -a)
    if string match -q '__async_prompt_orig_*' -- $func
      functions -e $func
    end
  end
end
