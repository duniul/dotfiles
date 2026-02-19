function aws-login-sso -d "Log in with AWS SSO and extract credentials with yawsso."
    set -l profiles $argv

    if [ -z "$profiles" ]
        set profiles $AWS_PROFILE
    end

    # Since there's no way to easily check if we're logged in, try running yawsso immediately.
    set -l yawsso_result (yawsso -p $profiles)

    # Check if we need to log in first.
    if [ $status -ne 0 ]
        if string match -q -r -i "(Can not find valid AWS CLI v2 SSO login)|(Try login again)" $yawsso_result
            echo "Not logged in with AWS SSO. Trying to log in first..."
            echo

            set_color --dim cyan
            echo "> sso login --profile $profiles[1]"
            set_color normal
            set_color --dim
            set -l sso_login_output (aws sso login --profile $profiles[1] 2>&1 | tee /dev/tty)
            set_color normal
            echo

            # aws sso login always exits with 0, so we need to check the output.
            if string match -q "*error occurred*" $sso_login_output
                # Failed to log in with AWS SSO.
                set_color red
                echo "Failed to log in with AWS SSO."
                set_color normal
                return 1
            else
                # Successfully logged in with AWS SSO.
                # Reload profiles
                set -l yawsso_result (yawsso -p $profiles)
            end
        else
            # Unknown error happened.
            set_color red
            echo "Failed to load AWS SSO profiles!"
            set_color normal

            echo $yawsso_result
            return 1
        end
    end

    set -l joined_profiles (string join "\\e[0m, \\e[0;33m" $profiles)

    echo -n "Loaded AWS SSO profiles: "
    echo -n -e "\\e[0;33m$joined_profiles\\e[0m"
    echo
end
