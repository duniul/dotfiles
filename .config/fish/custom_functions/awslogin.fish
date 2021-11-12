function awslogin -d "Log in with aws sso and extract credentials with yawsso."
    set profile $argv[1]

    # If no profile is passed, use the the AWS_PROFILE.
    if [ -z "$profile" ]
        set profile $AWS_PROFILE
    end

    echo "Logging in with profile: $profile"
    echo

    aws sso login --profile $profile
    yawsso --profile $profile
end
