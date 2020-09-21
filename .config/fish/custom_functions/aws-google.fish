function aws-google -d "Log in with aws-google-auth and extract credentials with aws-export-profile."
    if [ -n "$AWS_PROFILE" ]
        set profile $AWS_PROFILE
    else
        set profile "sts"
    end

    getopts $argv | while read -l key value
        if test $key = "profile"; or test $key = "p"
            set profile $value
        end
    end

    aws-google-auth $argv
    eval aws-export-profile $profile >/dev/null && echo "Exported $profile credentials as env vars!"
end
