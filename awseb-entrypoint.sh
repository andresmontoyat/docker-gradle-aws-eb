#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

function usage() {
    printf "This script must be run with super-user privileges\n"
    printf "Environment variabled definition:\n"
    printf "AWSEB_APP_NAME: AWS Elastickbeastalk application name\n"
    printf "AWSEB_ENV_NAME: AWS Elastickbeastalk environment name\n"
    printf "AWSEB_S3_BUCKET: AWS S3 Bucket Name\n"
    printf "AWSEB_S3_KEY: AWS S3 Bucket Key\n"
    printf "AWSEB_RELEASE_VERSION: Name for release version file upload to AWS S3\n"
    printf "LOCALDIR_RELEASE_VERSION: Location for release version file\n"
}

function s3() { 
    { 
        aws s3 cp "$LOCALDIR_RELEASE_VERSION" "s3://$AWSEB_S3_BUCKET/$AWSEB_S3_KEY/$AWSEB_RELEASE_VERSION" --expire "$(date -d "+15 days" -u +"%Y-%m-%dT%H:%M:%SZ")"
    } || {
        return 1
    }
}

function eb() {
    {    
        aws elasticbeanstalk create-application-version \
            --application-name "$AWSEB_APP_NAME" \
            --version-label "$AWSEB_RELEASE_VERSION" \
            --description "Automatic Deployment for $AWSEB_RELEASE_VERSION" \
            --source-bundle S3Bucket="$AWSEB_S3_BUCKET",S3Key="$AWSEB_S3_KEY/$AWSEB_RELEASE_VERSION" --auto-create-application
    } || {
        echo "An error occurred while trying to execute aws eb create-application-version command."
        return 1
    }

    {
        aws elasticbeanstalk update-environment \
            --application-name "$AWSEB_APP_NAME" \
            --environment-name "$AWSEB_ENV_NAME" \
            --version-label "$AWSEB_RELEASE_VERSION"
    } || {
        echo "An error occurred while trying to execute aws eb update-environment command."
        return 1
    }
}

printf "Starting the AWS Beanstalk deployment\n"

if [[ $# -ne 0 ]]; then
    if ([[ -n "$1" ]]) && [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then 
	    usage && exit 0
    fi
fi 

if [[ -n "$LOCALDIR_RELEASE_VERSION" ]] && [[ -n "$AWSEB_S3_BUCKET" ]] && [[ -n "$AWSEB_S3_KEY" ]] && [[ -n "$AWSEB_RELEASE_VERSION" ]]; then
    
    s3 || { printf "An error occurred while trying to execute aws s3 command" && exit 1; }

    if [[ -n "$AWSEB_APP_NAME" ]] && [[ -n "$AWSEB_ENV_NAME" ]]; then 
        eb || { printf "An error occurred while trying to execute aws eb command" && exit 1; }

        printf "Ending the AWS Beanstalk deployment"
        printf "AWS Beanstalk deployment is done"

        exit 0
    fi
fi

printf "The environment variables are null\n"
exit 1
