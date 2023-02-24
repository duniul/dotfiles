function aws-login-ecr -d "Fetches ECR login password and securely logs in with Docker."
    argparse --name=aws-login-ecr 'p/profile=' 'r/region=' -- $argv

    set -l profile $_flag_profile
    set -l region $_flag_region

    # fall back to AWS_PROFILE if it exists, otherwise default
    if test -z "$profile"
        if test -n "$AWS_PROFILE"
            set profile $AWS_PROFILE
        else
            set profile default
        end
    end


    # use default region if none is set
    if test -z "$region"
        set region (aws configure get region --profile $profile)
    end

    set -l aws_account_id (aws sts get-caller-identity --output text --query "Account")

    # use default region if none is set
    if test -z "$aws_account_id"
        echo "Could not get AWS account ID."
        return 1
    end

    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$aws_account_id.dkr.ecr.$region.amazonaws.com"
end
